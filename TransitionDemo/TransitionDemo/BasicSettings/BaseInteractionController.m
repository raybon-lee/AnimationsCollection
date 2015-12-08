//
//  BaseInteractionController.m
//  TransitionDemo
//
//  Created by macmimi on 15/12/8.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "BaseInteractionController.h"

@implementation BaseInteractionController
- (void)wireToViewController:(UIViewController *)viewController forOperation:(InteractionOperation)operation {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

@end
