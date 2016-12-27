//
//  ViewController.m
//  01图层与视图
//
//  Created by SunYang on 16/12/27.
//  Copyright © 2016年 SunYang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //添加子图层
    [self.layerView.layer addSublayer:blueLayer];
}
@end
