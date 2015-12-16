//
//  RectZoomAnimationController.h
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationControllerProtocol.h"
@protocol RectZoomAnimationDelegate;

@interface RectZoomAnimationController : NSObject<AnimationControllerProtocol>
@property (weak, nonatomic) id<RectZoomAnimationDelegate> rectZoomDelegate;

@property (assign, nonatomic) BOOL shouldFadeBackgroundViewController;
@property (assign, nonatomic) CGFloat animationSpringDampening;
@property (assign, nonatomic) CGFloat animationSpringVelocity;
@end

@protocol RectZoomAnimationDelegate <NSObject>

- (CGRect)rectZoomPosition;

@end