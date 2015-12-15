//
//  SimpleColorViewController.h
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleColorViewController : UIViewController

@property (nonatomic, strong) UIColor *backgroundColor;

- (id)initWithColor:(UIColor *)color;

@end
