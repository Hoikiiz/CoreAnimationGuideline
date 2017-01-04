//
//  ZAxleController.m
//  03-图层几何
//
//  Created by SunYang on 17/1/4.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ZAxleController.h"

@interface ZAxleController ()
@property (weak, nonatomic) CALayer *blueLayer;
@property (weak, nonatomic) CALayer *redLayer;
@end

@implementation ZAxleController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(150, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.00].CGColor;
    [self.view.layer addSublayer:blueLayer];
    self.blueLayer = blueLayer;
    
    CALayer *redLayer = [CALayer layer];
    redLayer.frame = CGRectMake(200, 100, 100, 100);
    redLayer.backgroundColor = [UIColor colorWithRed:1.00 green:0.45 blue:0.43 alpha:1.00].CGColor;
    [self.view.layer addSublayer:redLayer];
    self.redLayer = redLayer;
}
- (IBAction)zChangeClick:(id)sender {
    self.blueLayer.zPosition += 0.1;
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
} 

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
