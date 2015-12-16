//
//  TransitionsManager.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "TransitionsManager.h"
#import "UniqueTransition.h"
#import "AnimationControllerProtocol.h"
#import "TransitionInteractionController.h"

@interface TransitionsManager()
@property (strong, nonatomic) NSMutableDictionary *animationControllers;
@property (strong, nonatomic) NSMutableDictionary *animationControllerDirectionOverrides;
@property (strong, nonatomic) NSMutableDictionary *interactionControllers;
@end

@implementation TransitionsManager
+ (TransitionsManager *)shared{
    static TransitionsManager *_defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[self alloc] init];
    });
    
    return _defaultManager;
}

- (instancetype)init{
    self = [super init];
    if ( self ) {
        self.animationControllers = [[NSMutableDictionary alloc] init];
        self.animationControllerDirectionOverrides = [[NSMutableDictionary alloc] init];
        self.interactionControllers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (UniqueTransition *)setAnimationController:(id<AnimationControllerProtocol>)animationController
                          fromViewController:(Class)fromViewController
                                   forAction:(TransitionAction)action{
    return [self setAnimationController:animationController
                     fromViewController:fromViewController
                       toViewController:nil
                              forAction:action];
}

- (UniqueTransition *)setAnimationController:(id<AnimationControllerProtocol>)animationController
                          fromViewController:(Class)fromViewController
                            toViewController:(Class)toViewController
                                   forAction:(TransitionAction)action{
    UniqueTransition *keyValue = nil;
    
    for ( NSUInteger x = 1; (x < (1 << (kTransitionActionCount - 1))); ) {
        if ( action & x ) {
            //x = 1 , action = 0..10 push = 00..01 pop = 00..10 present = 00..100 dismiss = 00..1000 pushpop = 00..11 presentdismiss = 00..1100
            if ( ((x & TransitionAction_Pop) && !(x & TransitionAction_Push)) ||
                ((x & TransitionAction_Dismiss) && !(x & TransitionAction_Present)) ) {
                keyValue = [[UniqueTransition alloc] initWithAction:x withFromViewControllerClass:toViewController withToViewControllerClass:fromViewController];
            }else {
                keyValue = [[UniqueTransition alloc] initWithAction:x withFromViewControllerClass:fromViewController withToViewControllerClass:toViewController];
            }
            [self.animationControllers setObject:animationController forKey:keyValue];
        }
        x = x << 1;
    }
    
    return keyValue;
}

- (UniqueTransition *)setInteractionController:(id<TransitionInteractionController>)interactionController
                            fromViewController:(Class)fromViewController
                              toViewController:(Class)toViewController
                                     forAction:(TransitionAction)action{
    UniqueTransition *keyValue = nil;
    
    for ( NSUInteger x = 1; (x < (1 << (kTransitionActionCount - 1))); ) {
        if ( action & x ) {
            UniqueTransition *keyValue = nil;
            if ( ((x & TransitionAction_Pop) && !(x &TransitionAction_Push)) ||
                ((x & TransitionAction_Dismiss) && !(x &TransitionAction_Present)) ) {
                keyValue = [[UniqueTransition alloc] initWithAction:x withFromViewControllerClass:toViewController withToViewControllerClass:fromViewController];
            }
            else {
                keyValue = [[UniqueTransition alloc] initWithAction:x withFromViewControllerClass:fromViewController withToViewControllerClass:toViewController];
            }
            
            [self.interactionControllers setObject:interactionController forKey:keyValue];
        }
        x = x << 1;
    }
    
    return keyValue;
}

- (void)overrideAnimationDirection:(BOOL)override withTransition:(UniqueTransition *)transitionKey{
    [self.animationControllerDirectionOverrides setObject:[NSNumber numberWithBool:override] forKey:transitionKey];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    UniqueTransition *keyValue = [[UniqueTransition alloc] initWithAction:TransitionAction_Present withFromViewControllerClass:[source class] withToViewControllerClass:[presented class]];
    id<AnimationControllerProtocol> animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
    if ( animationController == nil ) {
        keyValue.toViewControllerClass = nil;
        animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
    }
    if ( animationController == nil ) {
        animationController = self.defaultPresentDismissAnimationController;
    }
    
    if ( (animationController != nil) && (![[self.animationControllerDirectionOverrides objectForKey:keyValue] boolValue]) ) {
        animationController.isPositiveAnimation = YES;
    }
    
    return animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    UniqueTransition *keyValue = [[UniqueTransition alloc] initWithAction:TransitionAction_Dismiss withFromViewControllerClass:[dismissed class] withToViewControllerClass:nil];
    id<AnimationControllerProtocol> animationController = nil;
    
    // Find the dismissed view controller's view controller it is returning to
    UIViewController *presentingViewController = dismissed.presentingViewController;
    if ( [presentingViewController isKindOfClass:[UINavigationController class]] ) {
        UIViewController *childVC = (UIViewController *)[[presentingViewController childViewControllers] lastObject];
        if ( childVC != nil ) {
            keyValue.toViewControllerClass = [childVC class];
            animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
            if ( animationController == nil ) {
                keyValue.toViewControllerClass = nil;
                animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
            }
            if ( animationController == nil ) {
                keyValue.toViewControllerClass = [childVC class];
                keyValue.fromViewControllerClass = nil;
                animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
            }
        }
    }
    if ( animationController == nil ) {
        keyValue.toViewControllerClass = nil;
        keyValue.fromViewControllerClass = [dismissed class];
        animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
        
        // TODO: Check if from vc class is a navigation controller as well...
    }
    if ( animationController == nil ) {
        animationController = self.defaultPresentDismissAnimationController;
    }
    
    if ( (animationController != nil) && (![[self.animationControllerDirectionOverrides objectForKey:keyValue] boolValue]) ) {
        animationController.isPositiveAnimation = NO;
    }
    
    return animationController;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    // Find the animator in the animationcontrollers list
    // Get **ITS** from and to VC information!
    __block id returnInteraction = nil;
    [self.animationControllers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id<AnimationControllerProtocol> animationController = (id<AnimationControllerProtocol>)obj;
        UniqueTransition *keyValue = (UniqueTransition *)key;
        if ( animator == animationController && keyValue.transitionAction & TransitionAction_Present ) {
            id<TransitionInteractionController> interactionController = (id<TransitionInteractionController>)[self.interactionControllers objectForKey:keyValue];
            
            if ( interactionController == nil ) {
                keyValue.toViewControllerClass = nil;
                interactionController = (id<TransitionInteractionController>)[self.interactionControllers objectForKey:keyValue];
            }
            if( (interactionController != nil) && (interactionController.isInteractive) ) {
                returnInteraction = interactionController;
                *stop = YES;
            }
        }
    }];
    
    return returnInteraction;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    __block id returnInteraction = nil;
    [self.animationControllers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id<AnimationControllerProtocol> animationController = (id<AnimationControllerProtocol>)obj;
        UniqueTransition *keyValue = (UniqueTransition *)key;
        if ( animator == animationController && keyValue.transitionAction & TransitionAction_Dismiss ) {
            id<TransitionInteractionController> interactionController = (id<TransitionInteractionController>)[self.interactionControllers objectForKey:keyValue];
            if ( interactionController == nil ) {
                keyValue.fromViewControllerClass = nil;
                interactionController = (id<TransitionInteractionController>)[self.interactionControllers objectForKey:keyValue];
            }
            if( (interactionController != nil) && (interactionController.isInteractive) ) {
                returnInteraction = interactionController;
                *stop = YES;
            }
        }
    }];
    
    return returnInteraction;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    return [self interactionControllerForAction:TransitionAction_PushPop withAnimationController:animationController];
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    UniqueTransition *keyValue = [[UniqueTransition alloc] initWithAction:(operation == UINavigationControllerOperationPush) ? TransitionAction_Push : TransitionAction_Pop
                                                  withFromViewControllerClass:[fromVC class]
                                                    withToViewControllerClass:[toVC class]];
    id<AnimationControllerProtocol> animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
    if ( animationController == nil ) {
        keyValue.toViewControllerClass = nil;
        animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
    }
    if ( animationController == nil ) {
        keyValue.toViewControllerClass = [toVC class];
        keyValue.fromViewControllerClass = nil;
        animationController = (id<AnimationControllerProtocol>)[self.animationControllers objectForKey:keyValue];
    }
    if ( animationController == nil ) {
        animationController = self.defaultPushPopAnimationController;
    }
    
    if ( ![[self.animationControllerDirectionOverrides objectForKey:keyValue] boolValue] ) {
        if ( operation == UINavigationControllerOperationPush ) {
            animationController.isPositiveAnimation = YES;
        } else if ( operation == UINavigationControllerOperationPop )	{
            animationController.isPositiveAnimation = NO;
        }
    }
    
    return animationController;
}

#pragma mark - UIInteractionController Caching

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForAction:(TransitionAction)action withAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController{
    for ( UniqueTransition *key in self.interactionControllers ) {
        id<TransitionInteractionController> interactionController = [self.interactionControllers objectForKey:key];
        if ( (interactionController.action & action) && [interactionController isInteractive] ) {
            return interactionController;
        }
    }
    
    return nil;
}

@end
