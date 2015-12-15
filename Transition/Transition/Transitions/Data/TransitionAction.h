//
//  TransitionAction.h
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#ifndef TransitionAction_h
#define TransitionAction_h

#define kTransitionActionCount        5

/**
 *  All the recognized transition action types.
 */
typedef NS_ENUM (NSInteger, TransitionAction) {
    TransitionAction_Push             = (1 << 0),
    TransitionAction_Pop              = (1 << 1),
    TransitionAction_Present          = (1 << 2),
    TransitionAction_Dismiss          = (1 << 3),
    TransitionAction_Tab              = (1 << 4),
    TransitionAction_PushPop          = TransitionAction_Push|TransitionAction_Pop,
    TransitionAction_PresentDismiss   = TransitionAction_Present|TransitionAction_Dismiss,
    TransitionAction_Any              = TransitionAction_Present|TransitionAction_Dismiss|TransitionAction_Tab,
};
#endif /* TransitionAction_h */
