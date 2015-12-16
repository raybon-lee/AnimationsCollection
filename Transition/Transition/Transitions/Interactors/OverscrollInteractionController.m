//
//  OverscrollInteractionController.m
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "OverscrollInteractionController.h"
static const CGFloat kOverscrollInteractionDefaultCompletionPercentage    = 0.35f;
static const CGFloat kOverscrollInteractionDefaultTopStartDistance        = 25.0f;
static const CGFloat kOverscrollInteractionDefaultBottomStartDistance     = 25.0f;
static const CGFloat kOverscrollInteractionDefaultTranslationDistance     = 200.0f;

@interface OverscrollInteractionController()
@property (assign, nonatomic) CGFloat lastYOffset;
@end

@implementation OverscrollInteractionController
@synthesize action = _action;
@synthesize isInteractive = _isInteractive;
@synthesize nextViewControllerDelegate = _delegate;
@synthesize shouldCompleteTransition = _shouldCompleteTransition;


#pragma mark - RZTransitionInteractor Protocol

- (void)attachViewController:(UIViewController *)viewController withAction:(TransitionAction)action{
    self.fromViewController = viewController;
    self.action = action;
}

- (void)watchScrollView:(UIScrollView *)scrollView{
    [scrollView setDelegate:self];
}

#pragma mark - UIPercentDrivenInteractiveTransition
- (CGFloat)completionSpeed{
    return 1 - self.percentComplete;
}

#pragma mark - Interaction Logic

- (CGFloat)completionPercent{
    return kOverscrollInteractionDefaultCompletionPercentage;
}

- (CGFloat)translationPercentageWithScrollView:(UIScrollView *)scrollView isScrollingDown:(BOOL)isScrollingDown{
    if ( isScrollingDown ) {
        return ((scrollView.contentOffset.y + kOverscrollInteractionDefaultTopStartDistance) / kOverscrollInteractionDefaultTranslationDistance) * -1;
    }else {
        return ((scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height - kOverscrollInteractionDefaultBottomStartDistance) / kOverscrollInteractionDefaultTranslationDistance);
    }
}

- (BOOL)scrollViewPastStartLocationWithScrollView:(UIScrollView *)scrollview isScrollingDown:(BOOL)isScrollingDown{
    if ( isScrollingDown ) {
        return (scrollview.contentOffset.y < kOverscrollInteractionDefaultTopStartDistance);
    }else {
        return ((scrollview.contentOffset.y + scrollview.frame.size.height - scrollview.contentSize.height) > kOverscrollInteractionDefaultBottomStartDistance);
    }
}

- (void)updateInteractionWithPercentage:(CGFloat)percentage{
    self.shouldCompleteTransition = percentage > [self completionPercent];
    [self updateInteractiveTransition:percentage];
}

- (void)completeInteractionWithScrollView:(UIScrollView *)scrollView{
    if ( self.isInteractive ) {
        self.isInteractive = NO;
        if( self.shouldCompleteTransition ) {
            [scrollView setDelegate:nil];
        }
        self.shouldCompleteTransition ? [self finishInteractiveTransition] : [self cancelInteractiveTransition];
    }
}

- (void)beginTransition{
    if ( !self.isInteractive ) {
        self.isInteractive = YES;
        if ( self.action & TransitionAction_Push ) {
            [self.fromViewController.navigationController pushViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES];
        }else if ( self.action & TransitionAction_Present ) {
            [self.fromViewController presentViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES completion:nil];
        }else if ( self.action & TransitionAction_Pop ) {
            [self.fromViewController.navigationController popViewControllerAnimated:YES];
        }else if ( self.action & TransitionAction_Dismiss ) {
            [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

// TODO: break out into helper class or base class
#pragma mark - RZTransition Action Helpers
+ (BOOL)actionIsPresentOrDismissWithAction:(NSUInteger)action{
    return ((action & TransitionAction_Present) || (action & TransitionAction_Dismiss));
}

+ (BOOL)actionIsPushOrPopWithAction:(NSUInteger)action{
    return ((action & TransitionAction_Push) || (action & TransitionAction_Pop));
}

+ (BOOL)actionIsPushOrPresentWithAction:(NSUInteger)action{
    return ((action & TransitionAction_Present) || (action & TransitionAction_Push));
}

+ (BOOL)actionIsDismissOrPopWithAction:(NSUInteger)action{
    return ((action & TransitionAction_Dismiss) || (action & TransitionAction_Pop));
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    BOOL overScrollDown = scrollView.contentOffset.y < 0;
    BOOL overScrollUp = scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height);
    BOOL scrollViewPastStartLocation = [self scrollViewPastStartLocationWithScrollView:scrollView isScrollingDown:overScrollDown];
    BOOL scrollingDirectionUp = scrollView.contentOffset.y - self.lastYOffset < 0;
    
    if ( !scrollViewPastStartLocation ) {
        return;
    }
    
    CGFloat percentage = [self translationPercentageWithScrollView:scrollView isScrollingDown:overScrollDown];
    
    if ( overScrollDown && [OverscrollInteractionController actionIsPushOrPresentWithAction:self.action] ) {
        if ( !self.isInteractive && scrollingDirectionUp && scrollViewPastStartLocation && !scrollView.isDecelerating ) {
            [self beginTransition];
        }else if ( scrollViewPastStartLocation ) {
            [self updateInteractionWithPercentage:percentage];
        }
    }else if ( overScrollUp && [OverscrollInteractionController actionIsDismissOrPopWithAction:self.action] ) {
        if ( !self.isInteractive && !scrollingDirectionUp && scrollViewPastStartLocation && !scrollView.isDecelerating ) {
            [self beginTransition];
        }else if ( scrollViewPastStartLocation ) {
            [self updateInteractionWithPercentage:percentage];
        }
    }
    
    self.lastYOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self completeInteractionWithScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self completeInteractionWithScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self completeInteractionWithScrollView:scrollView];
}

@end
