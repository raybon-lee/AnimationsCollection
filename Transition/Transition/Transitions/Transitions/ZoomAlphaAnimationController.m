//
//  ZoomAlphaAnimationController.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "ZoomAlphaAnimationController.h"
#import <UIKit/UIKit.h>
#import "NSObject+RZTransitionsViewHelpers.h"

#define kRZPushTransitionTime 0.35
#define kRZPushScaleChangePct 0.33

@implementation ZoomAlphaAnimationController
@synthesize isPositiveAnimation = _isPositiveAnimation;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *toView = [(NSObject *)transitionContext rzt_toView];
    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *container = [transitionContext containerView];
    
    if ( self.isPositiveAnimation ) {
        toView.frame = container.frame;
        [container insertSubview:toView belowSubview:fromView];
        toView.transform = CGAffineTransformMakeScale(1.0 - kRZPushScaleChangePct, 1.0 - kRZPushScaleChangePct);
        
        [UIView animateWithDuration:kRZPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformMakeScale(1.0 + kRZPushScaleChangePct, 1.0 + kRZPushScaleChangePct);
                             fromView.alpha = 0.0f;
                         }completion:^(BOOL finished) {
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformIdentity;
                             fromView.alpha = 1.0f;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }else {
        if (transitionContext.presentationStyle == UIModalPresentationNone) {
            [container insertSubview:toView belowSubview:fromView];
        }
        toView.transform = CGAffineTransformMakeScale(1.0 + kRZPushScaleChangePct, 1.0 + kRZPushScaleChangePct);
        toView.alpha = 0.0f;
        
        [UIView animateWithDuration:kRZPushTransitionTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.transform = CGAffineTransformIdentity;
                             toView.alpha = 1.0f;
                             fromView.alpha = 0.0f;
                             fromView.transform = CGAffineTransformMakeScale(1.0 - kRZPushScaleChangePct, 1.0 - kRZPushScaleChangePct);
                         }
                         completion:^(BOOL finished) {
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformIdentity;
                             toView.alpha = 1.0f;
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return kRZPushTransitionTime;
}
@end
