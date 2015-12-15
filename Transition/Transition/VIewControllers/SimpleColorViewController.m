//
//  SimpleColorViewController.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "SimpleColorViewController.h"
#import "UIColor+Random.h"

@implementation SimpleColorViewController

- (id)initWithColor:(UIColor *)color{
    self = [super init];
    if (self) {
        if (color) {
            _backgroundColor = color;
        }
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:self.backgroundColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelfOnTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Overidden Properties
- (UIColor *)backgroundColor{
    if (!_backgroundColor) {
        _backgroundColor = [UIColor randomColor];
    }
    return _backgroundColor;
}

#pragma mark - Handle Tap Genture Reconizer
- (void)dismissSelfOnTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
