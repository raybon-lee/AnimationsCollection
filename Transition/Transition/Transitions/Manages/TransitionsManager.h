//
//  TransitionsManager.h
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TransitionAction.h"
#import "UniqueTransition.h"

@protocol AnimationControllerProtocol;
@protocol TransitionInteractionController;
@class UniqueTransition;
@interface TransitionsManager : NSObject<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,UITabBarControllerDelegate>
/**
 *  The default animation to use when pushing or popping a @c UIViewController on a @c UINavigationController.  Uses nothing if nil.
 */
@property (strong, nonatomic) id<AnimationControllerProtocol> _Nullable defaultPushPopAnimationController;

/**
 *  The default animation to use when presenting or dismissing a @c UIViewController on a @c UIViewController.  Uses nothing if nil.
 */
@property (strong, nonatomic) id<AnimationControllerProtocol> _Nullable defaultPresentDismissAnimationController;

/**
 *  The default animation to use when moving between tabs on a @c UITabBarController.  Uses nothing if nil.
 */
@property (strong, nonatomic) id<AnimationControllerProtocol> _Nullable defaultTabBarAnimationController;

#pragma mark - Shared Instance

+ (TransitionsManager *_Nonnull)shared;

#pragma mark - Public API Set Animations and Interactions

/**
 *  Set the animation to use when transitioning from one @c UIViewController class to any other @c UIViewController class.  The @c RZTransitionAction is the set of actions that this animation will be used for.  For example, if @c RZTransitionAction_Push is specified, the @c animationController specified will be used to animate from the @fromViewController to any other @UIViewController when pushing another view controller on top.
 *
 *  @param animationController The animation to use when transitioning.
 *  @param fromViewController  The @c UIViewController class that is being transitioned from.
 *  @param action              The bitmask of possible actions to use the @c animationController.  For example, specifying RZTransitionAction_Push|RZTransitionAction_Present will use this @c animationController for pushing and presenting from @c fromViewController.
 *
 *  @return A unique key object that can be used to reference this animation pairing.
 */
- (UniqueTransition * _Nonnull)setAnimationController:(id<AnimationControllerProtocol> _Nullable)animationController
                                     fromViewController:(Class  _Nonnull )fromViewController
                                              forAction:(TransitionAction)action;

/**
 *  Set the animation to use when moving from one @c UIViewController class to another, specific @c UIViewController class.  The @c RZTransitionAction is the set of actions that this animation will be used for.  For example, if @c RZTransitionAction_Push is specified, the @c animationController specified will be used to animate from the @fromViewController to the @toViewController when pushing a @toViewController on top of a @fromViewController.
 *
 *  @param animationController The animation to use when transitioning.
 *  @param fromViewController  The @c UIViewController class that is being transitioned from.
 *  @param toViewController    The @c UIViewController class that is being transitioned to.
 *  @param action              The bitmask of possible actions to use the @c animationController.  For example, specifying RZTransitionAction_Push|RZTransitionAction_Present will use this @c animationController for pushing and presenting from @c fromViewController to @c toViewController.
 *
 *  @return A unique key object that can be used to reference this animation pairing.
 */
- (UniqueTransition * _Nonnull )setAnimationController:(id<AnimationControllerProtocol> _Nullable)animationController
                                      fromViewController:(Class _Nullable )fromViewController
                                        toViewController:(Class _Nullable )toViewController
                                               forAction:(TransitionAction)action;

/**
 *  Set the interactor to use when transitioning from one @c UIViewController class to another, specific @c UIViewController class.  The @c RZTransitionAction is the set of actions that this animation will be used for.  For example, if @c RZTransitionAction_Push is specified, the @c interactionController specified will be used to control the current animation controller if the current animation controller is animating from the @fromViewController to the @toViewController when pushing a @toViewController on top of a @fromViewController.
 *
 *  @param interactionController The interaction controller to use when transitioning.
 *  @param fromViewController    The @c UIViewController class that is being transitioned from.
 *  @param toViewController      The @c UIViewController class that is being transitioned to.
 *  @param action                The bitmask of possible actions to use the @c interactionController.  For example, specifying RZTransitionAction_Push|RZTransitionAction_Present will use this @c interactionController for pushing and presenting from @c fromViewController to @c toViewController.
 *
 *  @return A unique key object that can be used to reference this interaction pairing.
 */
- (UniqueTransition * _Nonnull )setInteractionController:(id<TransitionInteractionController> _Nullable)interactionController
                                        fromViewController:(Class _Nullable )fromViewController
                                          toViewController:(Class _Nullable )toViewController
                                                 forAction:(TransitionAction)action;

/**
 *  Override the automatic transition direction (positive/negative) for a specific animation / view controller pairing.
 *
 *  @param override      Override if @c YES, ignore if @c NO.
 *  @param transitionKey The unique key for the animation / view controller pairing to override.
 */
- (void)overrideAnimationDirection:(BOOL)override withTransition:(UniqueTransition * _Nonnull)transitionKey;
@end
