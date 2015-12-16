//
//  OverscrollInteractionController.h
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionInteractionController.h"

@interface OverscrollInteractionController : UIPercentDrivenInteractiveTransition<TransitionInteractionController,UIScrollViewDelegate>

@property (strong, nonatomic) UIViewController *fromViewController;

- (void)watchScrollView:(UIScrollView *)scrollView;
- (CGFloat)completionPercent;
@end
