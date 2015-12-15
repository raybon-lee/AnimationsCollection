//
//  CardSlideAnimationController.h
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationControllerProtocol.h"

@interface CardSlideAnimationController : NSObject<AnimationControllerProtocol>
/**
 *  The duration of the transition.
 *
 *  Default transition time is 0.35 seconds
 */
@property (assign, nonatomic) NSTimeInterval transitionTime;

/**
 *  flag to set if it is going in the horiztonal orientation as opposed to vertical.
 *
 *  Defaults to YES
 */
@property (assign, nonatomic) BOOL horizontalOrientation;

/**
 *  The background color for the transition's container.
 *
 *  Default is [UIColor blackColor]
 */
@property (strong, nonatomic) UIColor *containerBackgroundColor;
@end
