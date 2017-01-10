//
//  ShadowViewController.m
//  04-视觉效果
//
//  Created by SunYang on 17/1/9.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ShadowViewController.h"

@interface ShadowViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView1;

@property (weak, nonatomic) IBOutlet UIView *layerView2;
@end

@implementation ShadowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layerView1.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"pica"].CGImage);
    self.layerView2.layer.contents = self.layerView1.layer.contents;
    
    //显示阴影
    self.layerView1.layer.shadowOpacity = 0.8f;
    self.layerView2.layer.shadowOpacity = 0.8f;
    
    //绘制一个矩形阴影
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, self.layerView1.bounds);
    self.layerView1.layer.shadowPath = squarePath;
    CGPathRelease(squarePath);
    //绘制一个圆形阴影
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.layerView2.bounds);
    self.layerView2.layer.shadowPath = circlePath;
    CGPathRelease(circlePath);
    
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
