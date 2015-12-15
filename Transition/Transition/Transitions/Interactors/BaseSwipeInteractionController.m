//
//  BaseSwipeInteractionController.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "BaseSwipeInteractionController.h"
#define kBaseSwipeInteractionDefaultCompletionPercentage  0.3f

@implementation BaseSwipeInteractionController
@synthesize action = _action;
@synthesize isInteractive = _isInteractive;
@synthesize nextViewControllerDelegate = _delegate;
@synthesize shouldCompleteTransition = _shouldCompleteTransition;

- (instancetype)init{
    self = [super init];
    if ( self ) {
        _reverseGestureDirection = NO;
    }
    return self;
}

- (void)attachViewController:(UIViewController *)viewController withAction:(TransitionAction)action{
    self.fromViewController = viewController;
    self.action = action;
    [self attachGestureRecognizerToView:self.fromViewController.view];
}

- (void)attachGestureRecognizerToView:(UIView *)view{
    [view addGestureRecognizer:self.gestureRecognizer];
}

-(void)dealloc{
    [self.gestureRecognizer.view removeGestureRecognizer:self.gestureRecognizer];
}

- (CGFloat)completionSpeed{
    return 1 - self.percentComplete;
}

#pragma mark - UIPanGestureRecognizer Delegate
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGFloat percentage = [self translationPercentageWithPanGestureRecongizer:panGestureRecognizer];
    BOOL positiveDirection = self.reverseGestureDirection ? ![self isGesturePositive:panGestureRecognizer] : [self isGesturePositive:panGestureRecognizer];
    
    switch ( panGestureRecognizer.state ) {
        case UIGestureRecognizerStateBegan:
            self.isInteractive = YES;
            
            if ( positiveDirection && self.nextViewControllerDelegate &&
                [self.nextViewControllerDelegate conformsToProtocol:@protocol(TransitionInteractionControllerDelegate)] ) {
                if ( self.action & TransitionAction_Push ) {
                    [self.fromViewController.navigationController pushViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES];
                }
                else if ( self.action & TransitionAction_Present ) {
                    // TODO: set and store a completion
                    [self.fromViewController presentViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES completion:nil];
                }
            }
            else {
                if ( self.action & TransitionAction_Pop ) {
                    [self cancelInteractiveTransition];
                    self.isInteractive = NO;
                    [self.fromViewController.navigationController popViewControllerAnimated:YES];
                }
                else if ( self.action & TransitionAction_Dismiss ) {
                    [self cancelInteractiveTransition];
                    self.isInteractive = NO;
                    [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            if ( self.isInteractive ) {
                self.shouldCompleteTransition = ( percentage >= [self swipeCompletionPercent] );
                [self updateInteractiveTransition:percentage];
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            self.isInteractive = NO;
            [self cancelInteractiveTransition];
            break;
            
        case UIGestureRecognizerStateEnded:
            if ( self.isInteractive ) {
                self.isInteractive = NO;
                if ( !self.shouldCompleteTransition || panGestureRecognizer.state == UIGestureRecognizerStateCancelled ) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            
        default:
            break;
    }
}

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return NO;
}

- (CGFloat)swipeCompletionPercent{
    return kBaseSwipeInteractionDefaultCompletionPercentage;
}

- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0.0f;
}

- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return 0.0f;
}

#pragma mark - Overridden Properties
- (UIGestureRecognizer *)gestureRecognizer{
    if ( !_gestureRecognizer ) {
        _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [_gestureRecognizer setDelegate:self];
    }
    return _gestureRecognizer;
}

@end
