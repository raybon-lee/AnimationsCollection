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
#import "VerticalSwipeInteractionController.h"
#import "PinchInteractionController.h"
#import "SimpleColorViewController.h"
#import "CirclePushAnimationController.h"

@interface ViewController ()<TransitionInteractionControllerDelegate>
@property (nonatomic, strong) id<TransitionInteractionController> pushPopInteractionController;
@property (nonatomic, strong) id<TransitionInteractionController> presentInteractionController;
@property (nonatomic, strong) id<TransitionInteractionController> pinchInteractionController;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[TransitionsManager shared] setInteractionController:self.presentInteractionController
                                       fromViewController:[self class]
                                         toViewController:nil
                                                forAction:TransitionAction_Present];
    
    [[TransitionsManager shared] setInteractionController:self.pinchInteractionController
                                       fromViewController:[self class]
                                         toViewController:nil
                                                forAction:TransitionAction_Present];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pushPopInteractionController = [[HorizontalInteractionController alloc] init];
    [self.pushPopInteractionController setNextViewControllerDelegate:self];
    [self.pushPopInteractionController attachViewController:self
                                                 withAction:TransitionAction_PushPop];
    
    self.presentInteractionController = [[VerticalSwipeInteractionController alloc] init];
    [self.presentInteractionController setNextViewControllerDelegate:self];
    [self.presentInteractionController attachViewController:self withAction:TransitionAction_Present];
    
    self.pinchInteractionController = [PinchInteractionController new];
    [self.pinchInteractionController setNextViewControllerDelegate:self];
    [self.pinchInteractionController attachViewController:self withAction:TransitionAction_Present];
    
    [[TransitionsManager shared] setAnimationController:[[CardSlideAnimationController alloc] init]
                                       fromViewController:[self class]
                                                forAction:TransitionAction_PushPop];
    
    [[TransitionsManager shared] setInteractionController:self.pushPopInteractionController
                                         fromViewController:[self class]
                                           toViewController:nil
                                                  forAction:TransitionAction_PushPop];
    
    [[TransitionsManager shared] setAnimationController:[[ZoomAlphaAnimationController alloc] init]
                                       fromViewController:[self class]
                                         toViewController:[CollectionViewController class]
                                                forAction:TransitionAction_PushPop];
    
    [[TransitionsManager shared] setAnimationController:[[CirclePushAnimationController alloc] init]
                                       fromViewController:[self class]
                                                forAction:TransitionAction_PresentDismiss];
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

- (IBAction)push:(id)sender {
    [self.navigationController pushViewController:[self nextSimpleViewController] animated:true];
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)present:(id)sender {
    [self presentViewController:[self nextSimpleColorViewController] animated:YES completion:nil];
}

- (UIViewController *)nextViewControllerForInteractor:(id<TransitionInteractionController>)interactor{
    if ([interactor isKindOfClass:[VerticalSwipeInteractionController class]]) {
        return [self nextSimpleColorViewController];
    }else if ([interactor isKindOfClass:[PinchInteractionController class]]) {
        return [self nextSimpleColorViewController];
    }else {
        return [self nextSimpleViewController];
    }
}

- (UIViewController *)nextSimpleViewController{
    ViewController* newVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [newVC setTransitioningDelegate:[TransitionsManager shared]];
    return newVC;
}

- (UIViewController *)nextSimpleColorViewController{
    SimpleColorViewController* newColorVC = [[SimpleColorViewController alloc]init];
    [newColorVC setTransitioningDelegate:[TransitionsManager shared]];
    VerticalSwipeInteractionController *dismissInteractionController = [[VerticalSwipeInteractionController alloc] init];
    [dismissInteractionController attachViewController:newColorVC withAction:TransitionAction_Dismiss];
    [[TransitionsManager shared] setInteractionController:dismissInteractionController
                                       fromViewController:[self class]
                                         toViewController:nil
                                                forAction:TransitionAction_Dismiss];
    return newColorVC;
}
@end
