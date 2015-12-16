//
//  PinchInteractionController.m
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "PinchInteractionController.h"

static const CGFloat kPinchInteractionDefaultCompletionPercentage     = 0.5f;

@implementation PinchInteractionController
@synthesize action = _action;
@synthesize isInteractive = _isInteractive;
@synthesize nextViewControllerDelegate = _delegate;
@synthesize shouldCompleteTransition = _shouldCompleteTransition;

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

- (CGFloat)translationPercentageWithPinchGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    return pinchGestureRecognizer.scale / 2.0f;
}

- (BOOL)isPinchWithGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    return pinchGestureRecognizer.scale < 1.0f;
}

#pragma mark - UIPinchGestureRecognizer Delegate
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    CGFloat percentage = [self translationPercentageWithPinchGestureRecognizer:pinchGestureRecognizer];
    BOOL isPinch = [self isPinchWithGesture:pinchGestureRecognizer];
    
    switch ( pinchGestureRecognizer.state ) {
        case UIGestureRecognizerStateBegan:
            self.isInteractive = YES;
            
            if ( !isPinch && self.nextViewControllerDelegate && [self.nextViewControllerDelegate conformsToProtocol:@protocol(TransitionInteractionControllerDelegate)] ) {
                if ( self.action & TransitionAction_Push ) {
                    [self.fromViewController.navigationController pushViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES];
                }else if ( self.action & TransitionAction_Present ) {
                    // TODO: set and store a completion
                    [self.fromViewController presentViewController:[self.nextViewControllerDelegate nextViewControllerForInteractor:self] animated:YES completion:nil];
                }
            }else {
                if ( self.action & TransitionAction_Pop ) {
                    [self cancelInteractiveTransition];
                    self.isInteractive = NO;
                    [self.fromViewController.navigationController popViewControllerAnimated:YES];
                }else if ( self.action & TransitionAction_Dismiss ) {
                    [self cancelInteractiveTransition];
                    self.isInteractive = NO;
                    [self.fromViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            if ( self.isInteractive ) {
                self.shouldCompleteTransition = (percentage > kPinchInteractionDefaultCompletionPercentage);
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
                if ( !self.shouldCompleteTransition || pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled ) {
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

#pragma mark - Overridden Properties

- (UIGestureRecognizer *)gestureRecognizer
{
    if ( !_gestureRecognizer ) {
        _gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [_gestureRecognizer setDelegate:self];
    }
    return _gestureRecognizer;
}


@end
