//
//  ContentsRectController.m
//  02寄宿图
//
//  Created by SunYang on 16/12/30.
//  Copyright © 2016年 SunYang. All rights reserved.
//

#import "ContentsRectController.h"

@interface ContentsRectController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *contentViews;
@end

@implementation ContentsRectController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"dribbble-1"];
    CGFloat spaceX = 1.0 / 3.0;
    CGFloat spaceY = 1.0 / 2.0;
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 2; j ++) {
            //获取collection中的view
            UIView *layerView = self.contentViews[i * 2 + j];
            layerView.layer.contents = (__bridge id)image.CGImage;
            //计算，设置contentsRect
            layerView.layer.contentsRect = CGRectMake(i * spaceX, j * spaceY, spaceX, spaceY);
            
        }
    }
}



@end
