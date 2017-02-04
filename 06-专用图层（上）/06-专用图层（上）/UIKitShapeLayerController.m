//
//  UIKitShapeLayerController.m
//  06-专用图层（上）
//
//  Created by SunYang on 17/2/4.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "UIKitShapeLayerController.h"
#import "ShapeLayerView.h"
@interface UIKitShapeLayerController ()

@end

@implementation UIKitShapeLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    ShapeLayerView *shapeView = [ShapeLayerView new];
    [self.view addSubview:shapeView];
    shapeView.frame = CGRectMake(0, 0, 300, 300);
    shapeView.center = self.view.center;
    shapeView.backgroundColor = [UIColor clearColor];
}



@end
