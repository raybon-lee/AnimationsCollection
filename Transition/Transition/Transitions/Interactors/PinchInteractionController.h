//
//  PinchInteractionController.h
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionInteractionController.h"

@interface PinchInteractionController : UIPercentDrivenInteractiveTransition<TransitionInteractionController,UIGestureRecognizerDelegate>
@property (weak, nonatomic) UIViewController *fromViewController;
@property (strong, nonatomic) UIPinchGestureRecognizer *gestureRecognizer;

- (CGFloat)translationPercentageWithPinchGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer;
@end
