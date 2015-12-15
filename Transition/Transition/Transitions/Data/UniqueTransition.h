//
//  UniqueTransition.h
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitionAction.h"

@interface UniqueTransition : NSObject<NSCopying>
@property (assign, nonatomic) TransitionAction transitionAction;
@property (assign, nonatomic) Class fromViewControllerClass;
@property (assign, nonatomic) Class toViewControllerClass;

- (instancetype)initWithAction:(TransitionAction)action
   withFromViewControllerClass:(Class)fromViewController
     withToViewControllerClass:(Class)toViewController;
@end
