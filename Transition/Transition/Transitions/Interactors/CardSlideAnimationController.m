//
//  CardSlideAnimationController.m
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "CardSlideAnimationController.h"
#import "NSObject+RZTransitionsViewHelpers.h"

#define kRZSlideTransitionTime 0.35
#define kRZSlideScaleChangePct 0.33
@implementation CardSlideAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _transitionTime = kRZSlideTransitionTime;
        _horizontalOrientation = YES;
        _containerBackgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *toView = [(NSObject *)transitionContext rzt_toView];
    UIView *container = [transitionContext containerView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:container.bounds];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgView.backgroundColor = self.containerBackgroundColor;
    [container insertSubview:bgView atIndex:0];
    
    if ( self.isPositiveAnimation ) {
        [container insertSubview:toView belowSubview:fromView];
        toView.frame = container.frame;
        toView.transform = CGAffineTransformMakeScale(1.0 - kRZSlideScaleChangePct, 1.0 - kRZSlideScaleChangePct);
        toView.alpha = 0.1f;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.transform = CGAffineTransformIdentity;
                             toView.alpha = 1.0f;
                             if ( self.horizontalOrientation ) {
                                 fromView.transform = CGAffineTransformMakeTranslation(-container.bounds.size.width, 0);
                             }
                             else {
                                 fromView.transform = CGAffineTransformMakeTranslation(0, container.bounds.size.height);
                             }
                         }
                         completion:^(BOOL finished) {
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformIdentity;
                             [bgView removeFromSuperview];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    else {
        [container addSubview:toView];
        
        if ( self.horizontalOrientation ) {
            toView.transform = CGAffineTransformMakeTranslation(-container.bounds.size.width, 0);
        }
        else {
            toView.transform = CGAffineTransformMakeTranslation(0, container.bounds.size.height);
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformMakeScale(1.0 - kRZSlideScaleChangePct, 1.0 - kRZSlideScaleChangePct);
                             fromView.alpha = 0.1f;
                         }
                         completion:^(BOOL finished) {
                             toView.transform = CGAffineTransformIdentity;
                             fromView.transform = CGAffineTransformIdentity;
                             fromView.alpha = 1.0f;
                             [bgView removeFromSuperview];
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.transitionTime;
}
@end
