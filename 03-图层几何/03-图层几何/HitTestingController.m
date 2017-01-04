//
//  HitTestingController.m
//  03-图层几何
//
//  Created by SunYang on 17/1/4.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "HitTestingController.h"

@interface HitTestingController ()<CALayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) CALayer *blueLayer;
@end

@implementation HitTestingController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.00].CGColor;
    [self.layerView.layer addSublayer:blueLayer];
    self.blueLayer = blueLayer;
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//{
    // -containsPoint:
//    CGPoint point = [touches.anyObject locationInView:self.view];
//    //    转换为layerView中的坐标
//    point = [self.blueLayer convertPoint:point fromLayer:self.view.layer];
//    NSString *message = @"";
//    if ([self.blueLayer containsPoint:point]) {
//        message = @"点击位于蓝色视图中";
//    } else {
//        message = @"点击位于蓝色视图外";
//    }
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //-hitTest:
    CGPoint point = [touches.anyObject locationInView:self.view];
    CALayer *layer = [self.layerView.layer hitTest:point];
    NSString *message = @"";
    if (layer == self.blueLayer) {
        message = @"点击位于蓝色视图中";
    } else {
        message = @"点击位于蓝色视图外";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
