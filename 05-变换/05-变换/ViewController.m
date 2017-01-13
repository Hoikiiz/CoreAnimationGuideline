//
//  ViewController.m
//  05-变换
//
//  Created by SunYang on 17/1/13.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIView *layerView2;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.layerView.layer.contents = (__bridge id)[UIImage imageNamed:@"pica"].CGImage;
    self.layerView2.layer.contents = self.layerView.layer.contents;
    
}

- (IBAction)rotationClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    self.layerView.layer.affineTransform = transform;
}

- (IBAction)complexChangeClick:(id)sender {
    //创建一个transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    //缩小50%
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    //旋转30°
    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0);
    //平移
    transform = CGAffineTransformTranslate(transform, 200, 0);
    
    self.layerView.layer.affineTransform = transform;
}

- (IBAction)YRotationClick:(id)sender {
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform;
    
}
- (IBAction)prespectiveRotation:(id)sender {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform;
    
}
- (IBAction)vanishClick:(id)sender {
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = perspective;
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform1;
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    self.layerView2.layer.transform = transform2;
}


@end

























