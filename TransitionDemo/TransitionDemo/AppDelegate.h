//
//  AppDelegate.h
//  TransitionDemo
//
//  Created by macmimi on 15/12/8.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define AppDelegateAccessor ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@class ReversibleAnimationController,BaseInteractionController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ReversibleAnimationController *settingsAnimationController;
@property (strong, nonatomic) ReversibleAnimationController *navigationControllerAnimationController;
@property (strong, nonatomic) BaseInteractionController *navigationControllerInteractionController;
@property (strong, nonatomic) BaseInteractionController *settingsInteractionController;
@end

