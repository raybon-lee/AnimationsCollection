//
//  NavigationController.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "NavigationController.h"
#import "TransitionsManager.h"

@interface NavigationController()<UIGestureRecognizerDelegate>

@end

@implementation NavigationController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    __weak NavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [self.interactivePopGestureRecognizer setEnabled:YES];
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = [TransitionsManager shared];
    }
}
@end
