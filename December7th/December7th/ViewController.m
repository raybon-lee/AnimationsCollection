//
//  ViewController.m
//  December7th
//
//  Created by macmimi on 15/12/7.
//  Copyright © 2015年 Carmen. All rights reserved.
//

#import "ViewController.h"
#define WIDTH 100
#define IMAGE_COUNT 5

@interface ViewController (){
    UIImageView *_imageView;
    int _currentIndex;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.userInteractionEnabled = YES;
//    [self drawMyLayer];
//    [self drawLayeNoShapes];
    [self drawImageTransformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMyLayer{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CALayer *layer = [[CALayer alloc]init];
    layer.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.5 alpha:1.0].CGColor;
    layer.position = CGPointMake(size.width / 2.0, size.height/2.0);
    layer.bounds = CGRectMake(0, 0, WIDTH, WIDTH);
    layer.cornerRadius = WIDTH/2.0;
//    layer.anchorPoint = CGPointMake(1, 1);
    layer.masksToBounds = true;
    layer.borderWidth = 2.f;
    layer.borderColor = [UIColor orangeColor].CGColor;
    layer.delegate = self;
    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    [self.view.layer addSublayer:layer];
    [layer setNeedsDisplay];
}

#pragma mark 点击放大
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CALayer *layer=[self.view.layer.sublayers lastObject];
    CGFloat width=layer.bounds.size.width;
    if (width==WIDTH) {
        width=WIDTH*4;
    }else{
        width=WIDTH;
    }
    layer.bounds=CGRectMake(0, 0, width, width);
    layer.position=[touch locationInView:self.view];
    layer.cornerRadius=width/2;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//    CGContextSaveGState(ctx);
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -WIDTH);
    UIImage *image = [UIImage imageNamed:@"hello.jpg"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, WIDTH, WIDTH), image.CGImage);
//    CGContextRestoreGState(ctx);
}

//

- (void)drawLayeNoShapes{
    CGPoint position= CGPointMake(160, 200);
    CGRect bounds=CGRectMake(0, 0, WIDTH, WIDTH);
    CGFloat cornerRadius=WIDTH/2;
    CGFloat borderWidth=2;
    
    //阴影图层
    CALayer *layerShadow=[[CALayer alloc]init];
    layerShadow.bounds=bounds;
    layerShadow.position=position;
    layerShadow.cornerRadius=cornerRadius;
    layerShadow.shadowColor=[UIColor grayColor].CGColor;
    layerShadow.shadowOffset=CGSizeMake(2, 1);
    layerShadow.shadowOpacity=1;
    layerShadow.borderColor=[UIColor whiteColor].CGColor;
    layerShadow.borderWidth=borderWidth;
    [self.view.layer addSublayer:layerShadow];
    
    //容器图层
    CALayer *layer=[[CALayer alloc]init];
    layer.bounds=bounds;
    layer.position=position;
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.cornerRadius=cornerRadius;
    layer.masksToBounds=YES;
    layer.borderColor=[UIColor whiteColor].CGColor;
    layer.borderWidth=borderWidth;
    //设置内容（注意这里一定要转换为CGImage）
    UIImage *image=[UIImage imageNamed:@"hello.jpg"];
    //    layer.contents=(id)image.CGImage;
    [layer setContents:(id)image.CGImage];
    
    //添加图层到根图层
    [self.view.layer addSublayer:layer];
}

- (void)drawImageTransformation{
    //定义图片控件
    _imageView=[[UIImageView alloc]init];
    _imageView.frame=[UIScreen mainScreen].bounds;
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.image=[UIImage imageNamed:@"0.jpg"];//默认图片
    [self.view addSubview:_imageView];
    //添加手势
    UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
}

#pragma mark 向左滑动浏览下一张图片
-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture{
    [self transitionAnimation:YES];
}

#pragma mark 向右滑动浏览上一张图片
-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture{
    [self transitionAnimation:NO];
}


#pragma mark 转场动画
-(void)transitionAnimation:(BOOL)isNext{
    //1.创建转场动画对象
    CATransition *transition=[[CATransition alloc]init];
    
    //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
    transition.type=@"reveal";
    
    //设置子类型
    if (isNext) {
        transition.subtype=kCATransitionFromRight;
    }else{
        transition.subtype=kCATransitionFromLeft;
    }
    //设置动画时常
    transition.duration=1.0f;
    
    //3.设置转场后的新视图添加转场动画
    _imageView.image=[self getImage:isNext];
    [_imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
}

#pragma mark 取得当前图片
-(UIImage *)getImage:(BOOL)isNext{
    if (isNext) {
        _currentIndex=(_currentIndex+1)%IMAGE_COUNT;
    }else{
        _currentIndex=(_currentIndex-1+IMAGE_COUNT)%IMAGE_COUNT;
    }
    NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentIndex];
    return [UIImage imageNamed:imageName];
}
@end
