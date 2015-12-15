//
//  HorizontalInteractionController.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "HorizontalInteractionController.h"
#import "BaseSwipeInteractionController.h"

#define kRZHorizontalTransitionCompletionPercentage 0.3f

@implementation HorizontalInteractionController


- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer{
    return [self translationWithPanGestureRecongizer:panGestureRecognizer] < 0;
}

- (CGFloat)swipeCompletionPercent{
    return kRZHorizontalTransitionCompletionPercentage;
}

- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    return fabs([self translationWithPanGestureRecongizer:panGestureRecognizer] / panGestureRecognizer.view.bounds.size.width);
}

- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    return [panGestureRecognizer translationInView:panGestureRecognizer.view].x;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGFloat yTranslation = [panGestureRecognizer translationInView:panGestureRecognizer.view].y;
        return yTranslation == 0;
    }
    
    return YES;
}

@end
