//
//  VerticalSwipeInteractionController.m
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "VerticalSwipeInteractionController.h"
#define kVerticalTransitionCompletionPercentage 0.3f

@implementation VerticalSwipeInteractionController

- (BOOL)isGesturePositive:(UIPanGestureRecognizer *)panGestureRecognizer{
    return [self translationWithPanGestureRecongizer:panGestureRecognizer] < 0;
}

- (CGFloat)swipeCompletionPercent{
    return kVerticalTransitionCompletionPercentage;
}

- (CGFloat)translationPercentageWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    return fabs([self translationWithPanGestureRecongizer:panGestureRecognizer] / panGestureRecognizer.view.bounds.size.height);
}

- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    return [panGestureRecognizer translationInView:panGestureRecognizer.view].y;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGFloat xTranslation = [panGestureRecognizer translationInView:panGestureRecognizer.view].x;
        return xTranslation == 0;
    }
    
    return YES;
}

@end
