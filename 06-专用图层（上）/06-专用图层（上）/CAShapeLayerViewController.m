//
//  CAShapeLayerViewController.m
//  06-专用图层（上）
//
//  Created by SunYang on 17/2/4.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "CAShapeLayerViewController.h"

@interface CAShapeLayerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation CAShapeLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Core Animation 开始绘制");
    UIBezierPath *path = [[UIBezierPath alloc] init]; //这里使用了UIBezierPath 而不是像前几章直接使用 CGPathRef 可以有效地利用ARC来帮助我们管理内存
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [self.containerView.layer addSublayer:shapeLayer];
    NSLog(@"Core Animation 结束绘制");
}



@end
