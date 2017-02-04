//
//  LabelController.m
//  06-专用图层（上）
//
//  Created by SunYang on 17/2/4.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "LabelController.h"

@interface LabelController ()

@end

@implementation LabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"UILabel 开始渲染");
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    label.center = self.view.center;
    [self.view addSubview:label];
    
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentJustified;
    NSString *text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName:[UIColor blackColor],
                              NSFontAttributeName: label.font
                              };
    
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    attribs = @{
                NSForegroundColorAttributeName: [UIColor redColor],
                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                NSFontAttributeName: label.font
                };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    label.attributedText = string;
    NSLog(@"UILabel 结束渲染");
}





@end
