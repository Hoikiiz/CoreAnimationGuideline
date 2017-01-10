//
//  MaskViewController.m
//  04-视觉效果
//
//  Created by SunYang on 17/1/9.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "MaskViewController.h"

@interface MaskViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView1;
@property (weak, nonatomic) IBOutlet UIView *layerView2;
@property (weak, nonatomic) IBOutlet UIView *layerView3;

@end

@implementation MaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *redImage = [UIImage imageNamed:@"redImage"];
    UIImage *pica = [UIImage imageNamed:@"pica"];
    self.layerView1.layer.contents = (__bridge id)redImage.CGImage;
    self.layerView2.layer.contents = (__bridge id)pica.CGImage;
    
    //设置蒙版
    self.layerView3.layer.contents = self.layerView1.layer.contents;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.layerView3.bounds;
    maskLayer.contents = self.layerView2.layer.contents;
    self.layerView3.layer.mask = maskLayer;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
