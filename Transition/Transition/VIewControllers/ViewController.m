//
//  ViewController.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewController.h"
#import "HorizontalInteractionController.h"
#import "TransitionInteractionController.h"
#import "TransitionsManager.h"
#import "ZoomAlphaAnimationController.h"
#import "CardSlideAnimationController.h"

@interface ViewController ()<TransitionInteractionControllerDelegate>
@property (nonatomic, strong) id<TransitionInteractionController> pushPopInteractionController;
@property (nonatomic, strong) id<TransitionInteractionController> presentInteractionController;
@property (nonatomic, strong) id<TransitionInteractionController> pinchInteractionController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pushPopInteractionController = [[HorizontalInteractionController alloc] init];
    [self.pushPopInteractionController setNextViewControllerDelegate:self];
    [self.pushPopInteractionController attachViewController:self withAction:TransitionAction_PushPop];
    [[TransitionsManager shared] setInteractionController:self.pushPopInteractionController
                                         fromViewController:[self class]
                                           toViewController:nil
                                                  forAction:TransitionAction_PushPop];
    
    [[TransitionsManager shared] setAnimationController:[[ZoomAlphaAnimationController alloc] init]
                                       fromViewController:[self class]
                                         toViewController:[CollectionViewController class]
                                                forAction:TransitionAction_PushPop];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushCollectionView:(id)sender {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    CollectionViewController* Controller = [[CollectionViewController alloc]initWithCollectionViewLayout:flowLayout];
    [self.navigationController pushViewController:Controller animated:true];
}

@end
