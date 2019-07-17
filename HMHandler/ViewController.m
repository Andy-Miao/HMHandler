//
//  ViewController.m
//  HMHandler
//
//  Created by 胡苗 on 2019/7/17.
//  Copyright © 2019 胡苗. All rights reserved.
//

#import "ViewController.h"
#import "HMHandler.h"

static NSUInteger const TYPE_MESSAGE_TEST = 0;
static NSUInteger const TYPE_MESSAGE_LOG = 1;
@interface ViewController () <HMHandleDelegate>
@property (nonatomic, strong) HMHandler *handler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.handler = [[HMHandler alloc] initWithDelegate:self];
    
    [self.handler sendMessage:TYPE_MESSAGE_TEST];
    
    [self.handler sendMessage:TYPE_MESSAGE_LOG delay:1];
    // Do any additional setup after loading the view.
}

- (void)didHandleMessage:(HMMessage *)msg {
    switch (msg.what) {
        case TYPE_MESSAGE_TEST:
            NSLog(@"TYPE_MESSAGE_TEST");
            break;
        case TYPE_MESSAGE_LOG:
            [self.handler sendMessage:TYPE_MESSAGE_LOG delay:1];
            NSLog(@"TYPE_MESSAGE_LOG");
            break;
        default:
            break;
    }
}

@end
