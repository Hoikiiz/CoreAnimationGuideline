//
//  ViewController.m
//  03-图层几何
//
//  Created by SunYang on 17/1/4.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *minuteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hourImageView.layer.anchorPoint = CGPointMake(0.5, 0.7);
    self.minuteImageView.layer.anchorPoint = CGPointMake(0.5, 0.7);
    self.secondImageView.layer.anchorPoint = CGPointMake(0.5, 0.7);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
    //初始化指针的位置
    [self timeTick];
}


- (void)timeTick {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hourAngle = (components.hour / 12.0) * M_PI * 2.0;
    CGFloat minuteAngle = (components.minute / 60.0) * M_PI * 2.0;
    CGFloat secondAngle = (components.second / 60.0) * M_PI * 2.0;
    self.hourImageView.transform = CGAffineTransformMakeRotation(hourAngle);
    self.minuteImageView.transform = CGAffineTransformMakeRotation(minuteAngle);
    self.secondImageView.transform = CGAffineTransformMakeRotation(secondAngle);
}
@end
