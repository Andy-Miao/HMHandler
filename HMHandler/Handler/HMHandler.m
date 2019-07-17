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

//- (void)sendMessage:(int)what;
//- (void)sendMessage:(int)what delay:(int)delay;
//
//- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2;
//- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 delay:(int)delay;
//
//- (void)sendMessage:(int)what obj:(NSObject *)obj;
//- (void)sendMessage:(int)what obj:(NSObject *)obj delay:(int)delay;
//
//- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj;
//- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj delay:(int)delay;
//- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj waitUntilDone:(BOOL) waitUntilDone;
//
//- (void)removeMessages:(int)what;
//- (void)removeAllMessages;
@end
