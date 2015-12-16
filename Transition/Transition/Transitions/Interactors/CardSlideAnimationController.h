//
//  CardSlideAnimationController.h
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationControllerProtocol.h"
#import <UIKit/UIColor.h>

@interface CardSlideAnimationController : NSObject<AnimationControllerProtocol>
@property (assign, nonatomic) NSTimeInterval transitionTime;
@property (assign, nonatomic) BOOL horizontalOrientation;
@property (strong, nonatomic) UIColor *containerBackgroundColor;
@end
