//
//  CollectionViewController.m
//  Transition
//
//  Created by macmimi on 15/12/15.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "CollectionViewController.h"
#import "UIColor+Random.h"
#import "SimpleColorViewController.h"
#import "TransitionInteractionController.h"
#import "OverscrollInteractionController.h"
#import "RectZoomAnimationController.h"
#import "TransitionsManager.h"

#define kCollectionViewCellReuseId  @"kCollectionViewCellReuseId"
#define kCollectionViewNumCells     50
#define kCollectionViewCellSize     88

@interface CollectionViewController()<UIViewControllerTransitioningDelegate, RectZoomAnimationDelegate, TransitionInteractionControllerDelegate>
@property (nonatomic, assign) CGPoint                           circleTransitionStartPoint;
@property (nonatomic, assign) CGRect                            transitionCellRect;
@property (nonatomic, strong) OverscrollInteractionController   *presentOverscrollInteractor;
@property (nonatomic, strong) RectZoomAnimationController       *presentDismissAnimationController;
@end

@implementation CollectionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellReuseId];
    
    self.presentDismissAnimationController = [[RectZoomAnimationController alloc] init];
    [self.presentDismissAnimationController setRectZoomDelegate:self];
    
    self.circleTransitionStartPoint = CGPointZero;
    self.transitionCellRect = CGRectZero;
    
    [[TransitionsManager shared] setAnimationController:self.presentDismissAnimationController
                                     fromViewController:[self class]
                                              forAction:TransitionAction_PresentDismiss];
    
    [self setTransitioningDelegate:[TransitionsManager shared]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return kCollectionViewNumCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellReuseId forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor randomColor]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(kCollectionViewCellSize, kCollectionViewCellSize);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *cellBackgroundColor = [collectionView cellForItemAtIndexPath:indexPath].backgroundColor;
    UIViewController *colorVC = [self newColorVCWithColor:cellBackgroundColor];
    self.circleTransitionStartPoint = [collectionView convertPoint:[collectionView cellForItemAtIndexPath:indexPath].center toView:self.view];;
    self.transitionCellRect = [collectionView convertRect:[collectionView cellForItemAtIndexPath:indexPath].frame toView:self.view];
    [self presentViewController:colorVC animated:true completion:nil];
}

- (UIViewController *)newColorVCWithColor:(UIColor *)color{
    SimpleColorViewController *newColorVC = [[SimpleColorViewController alloc] initWithColor:color];
    [newColorVC setTransitioningDelegate:[TransitionsManager shared]];
    return newColorVC;
}

#pragma mark - TransitionInteractorDelegate
- (UIViewController *)nextViewControllerForInteractor:(id<TransitionInteractionController>)interactor{
    return [self newColorVCWithColor:nil];
}

#pragma mark - RectZoomAnimationDelegate
- (CGRect)rectZoomPosition{
    return self.transitionCellRect;
}
#pragma mark - CirclePushAnimationDelegate
- (CGPoint)circleCenter{
    return self.circleTransitionStartPoint;
}
- (CGFloat)circleStartingRadius{
    return (kCollectionViewCellSize / 2.0f);
}
@end
