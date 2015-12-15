//
//  UniqueTransition.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "UniqueTransition.h"

@implementation UniqueTransition

- (instancetype)initWithAction:(TransitionAction)action
   withFromViewControllerClass:(Class)fromViewController
     withToViewControllerClass:(Class)toViewController{
    self = [super init];
    if ( self ) {
        _transitionAction = action;
        _fromViewControllerClass = fromViewController;
        _toViewControllerClass = toViewController;
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone{
    UniqueTransition *copiedObject = [[[self class] allocWithZone:zone] init];
    
    copiedObject.transitionAction = self.transitionAction;
    copiedObject.toViewControllerClass = self.toViewControllerClass;
    copiedObject.fromViewControllerClass = self.fromViewControllerClass;
    
    return copiedObject;
}

- (NSUInteger)hash{
    return [[self fromViewControllerClass] hash] ^ [[self toViewControllerClass] hash] ^ [self transitionAction];
}

- (BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[UniqueTransition class]]) {
        return NO;
    }
    
    UniqueTransition *otherObject = (UniqueTransition *)object;
    
    return (otherObject.transitionAction & self.transitionAction) &&
    (otherObject.fromViewControllerClass == self.fromViewControllerClass) &&
    (otherObject.toViewControllerClass == self.toViewControllerClass);
}


@end
