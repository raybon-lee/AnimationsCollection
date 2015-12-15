//
//  AnimationControllerProtocol.h
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AnimationControllerProtocol <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL isPositiveAnimation;
@end
