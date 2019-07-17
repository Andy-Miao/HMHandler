//
//  HMHandler.h
//  HMHandler
//
//  Created by 胡苗 on 15/8/28.
//  Copyright (c) 2015年 胡苗. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HMMessage : NSObject
@property int what;
@property int arg1;
@property int arg2;
@property (nonatomic, strong) NSObject *obj;
+ (id)msgWithWhat:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj;

- (id)initWithWhat:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj;
@end
//MARK: 协议
@protocol HMHandleDelegate <NSObject>
@optional
- (void)didHandleMessage:(HMMessage *)msg;
@end

//MARK: HMHandler类
@interface HMHandler : NSObject

- (id)initWithDelegate:(id<HMHandleDelegate>)delegate;

- (void)sendMessage:(int)what;
- (void)sendMessage:(int)what delay:(int)delay;

- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2;
- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 delay:(int)delay;

- (void)sendMessage:(int)what obj:(NSObject *)obj;
- (void)sendMessage:(int)what obj:(NSObject *)obj delay:(int)delay;

- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj;
- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj delay:(int)delay;
- (void)sendMessage:(int)what arg1:(int)arg1 arg2:(int)arg2 obj:(NSObject *)obj waitUntilDone:(BOOL) waitUntilDone;

- (void)removeMessages:(int)what;
- (void)removeAllMessages;
@end


