//
//  ViewController.m
//  04-视觉效果
//
//  Created by SunYang on 17/1/9.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView1;
@property (weak, nonatomic) IBOutlet UIView *layerView2;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置圆角半径
    self.layerView1.layer.cornerRadius = 20.0f;
    self.layerView2.layer.cornerRadius = 20.0f;
    
    //设置边框
    self.layerView1.layer.borderWidth = 5.0f;
    self.layerView2.layer.borderWidth = 5.0f;
    
    //设置剪裁
    self.layerView2.layer.masksToBounds = YES;
    
    //设置阴影
    self.layerView1.layer.shadowOpacity = 0.8f;
    self.shadowView.layer.shadowOpacity = 0.8f;
    
    self.layerView1.layer.shadowOffset = CGSizeMake(0, 3);
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 3);
    
    self.layerView1.layer.shadowRadius = 5.0f;
    self.shadowView.layer.shadowRadius = 5.0f;
}

@end
