往期回顾：
[序章](http://www.jianshu.com/p/c4b7b37cf805)
[第一章](http://www.jianshu.com/p/dbf2069cc90b)
[第二章](http://www.jianshu.com/p/dae6ccdf3672)
[项目中使用的代码](https://github.com/Hoikiiz/CoreAnimationGuideline)

##布局
-------
`UIView`中比较重要的布局属性为`frame`, `bounds`, `center`。`CALayer`中对应的成为`frame`, ` bounds`, `position`。
其中`frame`表示的是图层的外部坐标，即图层在父视图上占据的空间。`center`(`position`)代表的是相对于父视图`anchorPoint`所在的位置，`anchorPoint`会在后面讲到，默认的话就是视图的中心点。

![View和Layer的坐标关系.png](http://upload-images.jianshu.io/upload_images/1687521-f43fe4610f8a58f1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>`UIView`的`frame`, `bounds`, `center`仅仅是存取方法，实际访问和改变的是位于试图下方的`layer`。并且 `frame` 是通过 `bounds`, `position` 和 `transform` 所计算出来的。

住当对图层做变换的时候,比如旋转或者缩放,实际上代表了覆盖在图层旋转之后的整个轴对齐的矩形区域,也就是说的宽高可能和 bounds 的宽高不再一致了。


![旋转后视图的frame与bounds.png](http://upload-images.jianshu.io/upload_images/1687521-909225936923f271.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##锚点(anchorPoint)
-------
前面说过 `center`(`position`)实际是`anchorPoint`相对于父视图的位置。也就是说可以通过修改`anchorPoint`来控制`frame`的位置。

![修改anchorPoint后的frame对比.png](http://upload-images.jianshu.io/upload_images/1687521-d921f6bfa008778d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`anchorPoint`使用的是单位坐标，图层左上角为{0, 0}，右下角为{1, 1}，默认值为{0.5, 0.5}。当然，anchorPoint也可以位于图层之外，也就是取值可以小于0或者大于1；

下面我们来做一个时钟：


![](http://upload-images.jianshu.io/upload_images/1687521-4256e4720b38f04f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
我们可以启用一个`NSTimer`，然后每隔一秒获取一次本地时间，并且对应的使用`transform`来旋转指针（`transform`属性会在后面讲到）。

```
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *minuteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
```


![没有修改anchorPoint的时钟.png](http://upload-images.jianshu.io/upload_images/1687521-8abeeae1bb57f405.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到旋转的支点以及指针的位置都十分奇怪，因为我们图层默认的`anchorPoint`是{0.5, 0.5}，但是现实中时钟的指针却很少有以中心为支点旋转的，所以我们可以修改一下`anchorPoint`来调整我们指针的位置和旋转的支点。在`viewDidLoad`中添加如下代码

```
self.hourImageView.layer.anchorPoint = CGPointMake(0.5, 0.7);
    self.minuteImageView.layer.anchorPoint = CGPointMake(0.5, 0.7);
    self.secondImageView.layer.anchorPoint = CGPointMake(0.5, 0.7);
```




![调整anchorPoint后的时钟.png](http://upload-images.jianshu.io/upload_images/1687521-5800d9df9d3d661b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##坐标系
-------

和视图一样，图层在父视图中也是按照层级关系放置的，如果父图层移动了，那么所有的子视图也是跟着一起移动。这样就可以将若干图层作为一个整体一起移动，但是有时候你需要知道一个图层的绝对位置,或者是相对于另一个图层的位置,而不是它当前父图层的位置，`CALayer`提供了不同坐标系之间相互转换的方法：
```
- (CGPoint)convertPoint:(CGPoint)point fromLayer:(CALayer *)layer;
- (CGPoint)convertPoint:(CGPoint)point toLayer:(CALayer *)layer;
- (CGRect)convertRect:(CGRect)rect fromLayer:(CALayer *)layer;
- (CGRect)convertRect:(CGRect)rect toLayer:(CALayer *)layer;
```

###翻转的几何结构
我们都知道图层的原点是左上角，但是在macOS中视图原点却是左下角，`Core Animation`可以通过 `geometryFlipped`属性来适配这两种情况，他决定了一个图层以及其子图层是否垂直翻转。

###Z坐标轴
`CALayer`与`UIView`的一大主要区别就是`CALayer`是存在于三维空间中的，除了`position`和`anchorPoint`之外，`CALayer`还有`zPosition`和`zAnchorPoint`这两个属性，二者都是在Z轴上描述图层位置的浮点类型。这里并没有引申出z轴方向上的bounds等属性，因为图层并没有厚度。写一个简单的例子，下面有红色和蓝色两个图层，红色图层在蓝色图层上方，我们稍微改变一下蓝色图层的zPosition，可以看到蓝色图层就会跑到红色图层上方

```
@interface ZAxleController ()
@property (weak, nonatomic) CALayer *blueLayer;
@property (weak, nonatomic) CALayer *redLayer;
@end

@implementation ZAxleController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(100, 50, 100, 100);
    blueLayer.backgroundColor = [UIColor colorWithRed:0.00 green:0.55 blue:1.00 alpha:1.00].CGColor;
    [self.view.layer addSublayer:blueLayer];
    self.blueLayer = blueLayer;
    
    CALayer *redLayer = [CALayer layer];
    redLayer.frame = CGRectMake(150, 100, 100, 100);
    redLayer.backgroundColor = [UIColor colorWithRed:1.00 green:0.45 blue:0.43 alpha:1.00].CGColor;
    [self.view.layer addSublayer:redLayer];
    self.redLayer = redLayer;
}
```
![红色图层在蓝色图层上方.png](http://upload-images.jianshu.io/upload_images/1687521-a9ded2c5cf2983fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


更改一下蓝色图层的zPosition（这里改变了0.1，理论上哪怕只是改变0.0000001效果也是一样的，但是由于编译器的原因，精度过小可能会出现问题，所以最好还是不要写的太小）。
```
- (IBAction)zChangeClick:(id)sender {
    self.blueLayer.zPosition += 0.1;
}
```

![改变了蓝色图层的zPosition.png](http://upload-images.jianshu.io/upload_images/1687521-b5a4b9749dec692f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##Hit Testing
-------
`CALayer` 并不关心任何响应链事件,所以不能直接处理触摸事件或者手势。但是它有一系列的方法帮你处理事件:` -containsPoint:` 和 `-hitTest:` 。
` -containsPoint:`传入一个点，如果这个点在当前图层的frame范围内，就返回YES，比如下面的例子，我们在`-touchesBegan: withEvent:`中判断点击是否位于蓝色图层内部。
```
@interface HitTestingController ()
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.view];
//    转换为layerView中的坐标
    point = [self.blueLayer convertPoint:point fromLayer:self.view.layer];
    NSString *message = @"";
    if ([self.blueLayer containsPoint:point]) {
        message = @"点击位于蓝色视图中";
    } else {
        message = @"点击位于蓝色视图外";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
@end
```

![蓝色图层被点击.png](http://upload-images.jianshu.io/upload_images/1687521-89ea1693121220c7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`-hitTest:`同样接收一个`CGPoint`类型的参数，返回图层本身或者包含这个节点的子图层，如果这个点在图层之外则返回nil。所以上面的代码也可以写成这个样子。
```
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
```
* 需要注意的是虽然我们可以通过zPosition改变我们看到的图层的位置，但实际上响应链的顺序并不会改变。

##自动布局
在`iOS6`中苹果引入了自动布局，在使用UIView的时候你可以使用`NSLayoutConstraint`的API使用自动布局，但如果想要随意控制`CALayer`的布局就需要手动操作。最简单的方法就是使用`CALayerDelegate`的方法：
```
- (void)layoutSublayersOfLayer:(CALayer *)layer;
```
当图层的`bounds`发生变化或者调用`-setNeedsLayout`的时候，这个方法就会被执行，你可以在这里手动的调整子图层的大小与位置。


##总结
-------
本章涉及了`CALayer` 的几何结构,包括它的 `frame` ,`position` 和 `bounds` ,介绍了三维空间内图层的概念,以及如何在独立的图层内响应事件,最后简单说明了在iOS平台,`Core Animation`对自动调整和自动布局支持的缺乏。在第四章“视觉效果”当中,我们接着介绍一些图层外表的特性。










