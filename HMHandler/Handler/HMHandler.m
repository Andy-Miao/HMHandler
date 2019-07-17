//
//  HMHandler.m
//  HMHandler
//
//  Created by 胡苗 on 15/8/28.
//  Copyright (c) 2015年 胡苗. All rights reserved.
//

#import "HMHandler.h"

@interface HMMessage ()
@property int delay;
@end

@implementation HMMessage

+ (id)msgWithWhat:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj {
    HMMessage *msg = [[HMMessage alloc] initWithWhat:what arg1:arg1 arg2:arg2 obj:obj];
    return msg;
}

- (id)initWithWhat:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj {
    if (self = [super init]) {
        self.what = what;
        self.arg1 = arg1;
        self.arg2 = arg2;
        self.obj  = obj;
    }
    return self;
}
@end

//MARK: HMHandler类
@interface HMHandler ()
@property (strong, nonatomic) id<HMHandleDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *msgList;
@property (strong, nonatomic) NSThread *targetThread;
@end

@implementation HMHandler

- (id)initWithDelegate:(id<HMHandleDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.msgList = [[NSMutableArray alloc]init];
        self.targetThread = [NSThread currentThread];
    }
    return self;
}

- (void)handleMessage:(HMMessage *)msg {
    NSLog(@"msg = %@ msglist.count=%ld",msg,(unsigned long)(unsigned long)self.msgList.count);
    if(![self.msgList containsObject:msg])
        return;
    @synchronized(self.msgList) {
        [self.msgList removeObject:msg];
    }
    NSLog(@"handleMessage %d msg.obj = %@", msg.what, msg.obj);
    if (self.delegate)
        [self.delegate didHandleMessage:msg];
}

- (void)dispatchMessage:(HMMessage *)msg {
    if (self.targetThread.isMainThread)
        [self handleMessage:msg];
    else
        [self performSelector:@selector(handleMessage:) onThread:self.targetThread withObject:msg waitUntilDone:YES];
}

- (void)sendMessageOnMainThread:(HMMessage *)msg {
    [self performSelector:@selector(dispatchMessage:) withObject:msg afterDelay:msg.delay];
}

- (void)sendMessage:(int)what {
    [self sendMessage:what arg1:0 arg2:0 obj:nil delay:0];
}

- (void)sendMessage:(int)what delay:(int)delay {
    [self sendMessage:what arg1:0 arg2:0 obj:nil delay:delay];
}

- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 {
    [self sendMessage:what arg1:arg1 arg2:arg2 obj:nil delay:0];
}
- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 delay:(int)delay {
    [self sendMessage:what arg1:arg1 arg2:arg2 obj:nil delay:delay];
}

- (void)sendMessage:(int)what obj:(NSObject *)obj {
    [self sendMessage:what arg1:0 arg2:0 obj:obj delay:0];
}
- (void)sendMessage:(int)what obj:(NSObject *)obj delay:(int)delay {
    [self sendMessage:what arg1:0 arg2:0 obj:obj delay:delay];
}

- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj {
    [self sendMessage:what arg1:arg1 arg2:arg2 obj:obj delay:0];
}
- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj delay:(int)delay {
    HMMessage *msg = [[HMMessage alloc] initWithWhat:what arg1:arg1 arg2:arg2 obj:obj];
    msg.delay = delay;
    @synchronized (self.msgList) {
        [self.msgList addObject:msg];
    }
    NSLog(@"sendMessage %d %@ %@", what, obj, [NSThread currentThread]);
    [self performSelectorOnMainThread:@selector(sendMessageOnMainThread:) withObject:msg waitUntilDone:NO];
}
- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj waitUntilDone:(BOOL) waitUntilDone {
    HMMessage *msg = [[HMMessage alloc] initWithWhat:what arg1:arg1 arg2:arg2 obj:obj];
    @synchronized(self.msgList) {
        [self.msgList addObject:msg];
    }
    [self performSelectorOnMainThread:@selector(handleMessage:) withObject:msg waitUntilDone: waitUntilDone];
}

- (void)removeMessages:(int)what {
    @synchronized (self.msgList) {
        NSUInteger n = self.msgList.count;
        for (NSInteger i = n - 1; i >= 0; i--) {
            HMMessage *msg = [self.msgList objectAtIndex:i];
            if (msg.what == what) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendMessageOnMainThread:) object:msg];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dispatchMessage:) object:msg];
                [self.msgList removeObject:msg];
            }
        }
    }
}
- (void)removeAllMessages {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    @synchronized (self.msgList) {
        [self.msgList removeAllObjects];
    }
}
@end
