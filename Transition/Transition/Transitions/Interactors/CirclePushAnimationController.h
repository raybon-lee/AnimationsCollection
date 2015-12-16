//
//  CirclePushAnimationController.h
//  Transition
//
//  Created by macmimi on 15/12/16.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "ZoomAlphaAnimationController.h"
@protocol CirclePushAnimationDelegate;

@interface CirclePushAnimationController : ZoomAlphaAnimationController<AnimationControllerProtocol>

@property (weak, nonatomic) id<CirclePushAnimationDelegate> circleDelegate;

@property (assign, nonatomic) CGFloat maximumCircleScale;

@property (assign, nonatomic) CGFloat minimumCircleScale;

@end

@protocol CirclePushAnimationDelegate <NSObject>

@optional

- (CGPoint)circleCenter;

- (CGFloat)circleStartingRadius;
@end
