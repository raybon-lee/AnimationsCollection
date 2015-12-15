//
//  TransitionInteractionController.h
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TransitionAction.h"

@protocol TransitionInteractionController;
@protocol TransitionInteractionControllerDelegate <NSObject>

- (UIViewController *)nextViewControllerForInteractor:(id<TransitionInteractionController>)interactor;

@end

@protocol TransitionInteractionController <UIViewControllerInteractiveTransitioning>

@property (assign, nonatomic, readwrite) BOOL isInteractive;

@property (assign ,nonatomic, readwrite) BOOL shouldCompleteTransition;

@property (assign, nonatomic, readwrite) TransitionAction action;

@property (weak, nonatomic) id<TransitionInteractionControllerDelegate> nextViewControllerDelegate;

- (void)attachViewController:(UIViewController *)viewController withAction:(TransitionAction)action;
@end
