//
//  BaseSwipeInteractionController.h
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitionInteractionController.h"

@interface BaseSwipeInteractionController : UIPercentDrivenInteractiveTransition<TransitionInteractionController, UIGestureRecognizerDelegate>
@property (weak, nonatomic) UIViewController *fromViewController;
@property (strong, nonatomic) UIPanGestureRecognizer *gestureRecognizer;
@property (assign, nonatomic) BOOL reverseGestureDirection;
- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer;
- (CGFloat)swipeCompletionPercent;
- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;
- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer;
@end
