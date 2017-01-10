//
//  OpacityViewController.m
//  04-视觉效果
//
//  Created by SunYang on 17/1/10.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "OpacityViewController.h"

@interface OpacityViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UILabel *labelView;

@end

@implementation OpacityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layerView.alpha = 0.5f;
    self.layerView.layer.shouldRasterize = YES;
    self.layerView.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
