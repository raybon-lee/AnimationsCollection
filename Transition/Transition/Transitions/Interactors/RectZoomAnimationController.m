//
//  RectZoomAnimationController.m
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "RectZoomAnimationController.h"
#import "NSObject+RZTransitionsViewHelpers.h"

static const CGFloat kRectZoomAnimationTime             = 0.7f;
static const CGFloat kRectZoomDefaultFadeAnimationTime  = 0.2f;
static const CGFloat kRectZoomDefaultSpringDampening    = 0.6f;
static const CGFloat kRectZoomDefaultSpringVelocity     = 15.0f;

@implementation RectZoomAnimationController

@synthesize isPositiveAnimation = _isPositiveAnimation;

- (instancetype)init{
    if (self = [super init]) {
        _shouldFadeBackgroundViewController = true;
        _animationSpringDampening = kRectZoomDefaultSpringDampening;
        _animationSpringVelocity = kRectZoomDefaultSpringVelocity;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *fromView = [(NSObject *)transitionContext rzt_fromView];
    UIView *toView = [(NSObject *)transitionContext rzt_toView];
    UIView *container = [transitionContext containerView];
    
    CGRect originalFrame = fromView.frame;
    CGRect cellFrame = CGRectZero;
    
    if ( [self.rectZoomDelegate respondsToSelector:@selector(rectZoomPosition)] ) {
        cellFrame = [self.rectZoomDelegate rectZoomPosition];
    }
    
    if ( self.isPositiveAnimation ) {
        toView.frame = fromView.frame;
        UIView *resizableSnapshotView = [toView resizableSnapshotViewFromRect:toView.bounds afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        resizableSnapshotView.frame = cellFrame;
        [container addSubview:resizableSnapshotView];
        
        [UIView animateWithDuration:kRectZoomDefaultFadeAnimationTime animations:^{
            if ( self.shouldFadeBackgroundViewController ) {
                fromView.alpha = 0.0f;
            }
        }];
        
        [UIView animateWithDuration:kRectZoomAnimationTime
                              delay:0
             usingSpringWithDamping:self.animationSpringDampening
              initialSpringVelocity:self.animationSpringVelocity
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             resizableSnapshotView.frame = originalFrame;
                         } completion:^(BOOL finished) {
                             [container addSubview:toView];
                             [resizableSnapshotView removeFromSuperview];
                             if ( self.shouldFadeBackgroundViewController ) {
                                 fromView.alpha = 1.0f;
                             }
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }else {
        UIView *resizableSnapshotView = [fromView resizableSnapshotViewFromRect:fromView.bounds afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        resizableSnapshotView.frame = fromView.frame;
        
        [container insertSubview:resizableSnapshotView aboveSubview:fromView];
        [container insertSubview:toView belowSubview:resizableSnapshotView];
        
        toView.alpha = 0.0f;
        
        [UIView animateWithDuration:kRectZoomDefaultFadeAnimationTime animations:^{
            toView.alpha = 1.0f;
        }];
        
        [UIView animateWithDuration:kRectZoomAnimationTime
                              delay:0
             usingSpringWithDamping:self.animationSpringDampening
              initialSpringVelocity:self.animationSpringVelocity
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{resizableSnapshotView.frame = cellFrame;}
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:kRectZoomDefaultFadeAnimationTime
                                              animations:^{resizableSnapshotView.alpha = 0.0f;}
                                              completion:^(BOOL finished) {
                                 [resizableSnapshotView removeFromSuperview];
                                 [container addSubview:fromView];
                                 [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                             }];
                         }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return kRectZoomAnimationTime;
}
@end
