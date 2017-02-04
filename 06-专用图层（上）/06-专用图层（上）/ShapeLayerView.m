//
//  ShapeLayerView.m
//  06-专用图层（上）
//
//  Created by SunYang on 17/2/4.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ShapeLayerView.h"

@implementation ShapeLayerView

- (void)drawRect:(CGRect)rect {
    NSLog(@"Core Graphics 开始绘制");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 5);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 175, 100);
    CGContextAddArc(context, 150, 100, 25, 0, 2*M_PI, NO);
    CGContextMoveToPoint(context, 150, 125);
    CGContextAddLineToPoint(context, 150, 175);
    CGContextAddLineToPoint(context, 125, 225);
    CGContextMoveToPoint(context, 150, 175);
    CGContextAddLineToPoint(context, 175, 225);
    CGContextMoveToPoint(context, 100, 150);
    CGContextAddLineToPoint(context, 200, 150);
    CGContextStrokePath(context);
    NSLog(@"Core Graphics 结束绘制");
}

@end
