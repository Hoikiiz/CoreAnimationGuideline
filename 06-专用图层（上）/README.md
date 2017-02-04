#Core Animation 第六章 专用图层（上）
往期回顾：
[序章](http://www.jianshu.com/p/c4b7b37cf805)
[第一章 - 图层树](http://www.jianshu.com/p/dbf2069cc90b)
[第二章 - 寄宿图](http://www.jianshu.com/p/dae6ccdf3672)
[第三章 - 图层几何](http://www.jianshu.com/p/f12d36b33450)
[第四章 - 视觉效果](http://www.jianshu.com/p/f9130ac64cdd)
[第五章 - 变换](http://www.jianshu.com/p/58bcf00b5901)
[项目中使用的代码](https://github.com/Hoikiiz/CoreAnimationGuideline)

本章节主要讨论了`CALayer`的一些子类以及用法，由于内容较多，所谓分成上下两章，另外本章开始我会尽量多穿插一些与`UIKit`相关API的对比。

##CAShapeLayer

CAShapeLayer可以说是个人感觉最实用的一个CALayer的子类了，因为我们通过CGPath和CAShapeLayer来创建不同形状的图层。CAShapeLayer的优点如下：
* 渲染快速。绘制同一图形比使用CoreGraphics更快。
* 内存利用率高。 CAShapeLayer不像普通的CALayer需要一个寄宿图形，所以无论CAShapeLayer多大都不会占用太多的内存。
* 不会被图层边界剪裁掉。
* 不会像素化。

###创建一个CGPath
使用`CAShapeLayer`绘制不同形状的图层时我们主要使用`CGPath`来表示形状，同时还需要一下几个常用的属性：
* `lineWith` 线宽
* `lineCap` 线条的结尾
* `lineJoin` 线条之间的连接点
需要注意的是这些属性同一个图层只能设置一次。
下面我们来绘制一个火柴人：



![绘制红色的火柴人](http://upload-images.jianshu.io/upload_images/1687521-12176c44bb545b85.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

使用CAShapeLayer绘制：

```
- (void)viewDidLoad {
[super viewDidLoad];
NSLog(@"Core Animation 开始绘制");
UIBezierPath *path = [[UIBezierPath alloc] init]; //这里使用了UIBezierPath 而不是像前几章直接使用 CGPathRef 可以有效地利用ARC来帮助我们管理内存
[path moveToPoint:CGPointMake(175, 100)];
[path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
[path moveToPoint:CGPointMake(150, 125)];
[path addLineToPoint:CGPointMake(150, 175)];
[path addLineToPoint:CGPointMake(125, 225)];
[path moveToPoint:CGPointMake(150, 175)];
[path addLineToPoint:CGPointMake(175, 225)];
[path moveToPoint:CGPointMake(100, 150)];
[path addLineToPoint:CGPointMake(200, 150)];

CAShapeLayer *shapeLayer = [CAShapeLayer layer];
shapeLayer.strokeColor = [UIColor redColor].CGColor;
shapeLayer.fillColor = [UIColor clearColor].CGColor;
shapeLayer.lineWidth = 5;
shapeLayer.lineJoin = kCALineJoinRound;
shapeLayer.lineCap = kCALineCapRound;
shapeLayer.path = path.CGPath;
[self.containerView.layer addSublayer:shapeLayer];
NSLog(@"Core Animation 结束绘制");
}
```

使用CoreGraphics绘制：
```
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
```

顺便对比一下两者绘制的时间，可以看到即便是如此简单的图形，两者都已经体现出了细微的差距。`CoreGraphics`需要1到3毫秒的时间 而`ShapeLayer`则只需要不到1毫秒。

![绘制图形消耗时间](http://upload-images.jianshu.io/upload_images/1687521-25c9c8460896f2a2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###圆角
上文中提到过cornerRadius属性，可以为图层设置圆角，而CAShapeLayer可以绘制指定的圆角，比如我们绘制一个有三个圆角和一个直角的矩形：
```
CGRect rect = CGRectMake(50, 50, 100, 100);
CGSize radii = CGSizeMake(20, 20);
UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
```
##CATextLayer

顾名思义，`CATextLayer`是用来绘制文字的。书中提到iOS6.0以前的`UILabel`是通过`WebKit`来实现绘制的，也就是说当文字量比较大的时候绘制压力会比较大，使用`CATextLayer`渲染速度会比`UILabel`快很多因为`CATextLayer`使用了`Core Text`，当然现在大家已经基本都适配到了iOS7.0以上，不过稍后我还是会来对比一下目前`CATextLayer`与`UILabel`的渲染速度。
```
- (void)viewDidLoad {
[super viewDidLoad];
CATextLayer *textLayer = [CATextLayer layer];
textLayer.frame = self.labelView.bounds;
[self.labelView.layer addSublayer:textLayer];

textLayer.foregroundColor = [UIColor blackColor].CGColor;
textLayer.alignmentMode = kCAAlignmentJustified;
textLayer.wrapped = YES;

UIFont *font = [UIFont systemFontOfSize:15];
CFStringRef fontName = (__bridge CFStringRef)font.fontName;
CGFontRef fontRef = CGFontCreateWithFontName(fontName);
//CATextLayer的字体与字号是分开设置的
textLayer.font = fontRef;
textLayer.fontSize = font.pointSize;
CGFontRelease(fontRef);

NSString *text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
textLayer.string = text;

}
```
![使用CATextLayer渲染文字](http://upload-images.jianshu.io/upload_images/1687521-120769936ccb8d56.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到我们的文本有一些像素画了，我们可以使用前面提到的contentScale来调整一下。
```
textLayer.contentsScale = [UIScreen mainScreen].scale;
```


![修复像素化后的文本](http://upload-images.jianshu.io/upload_images/1687521-666e831798006864.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>另外，`CATextLayer`的`string`属性并不是你想象的`NSString`类型，而是`id`类型。这样你既可以用`NSString`也可以用`NSAttributedString`来指定文本了（注意，`NSAttributedString`并不是`NSString`的子类）。富文本字符串是iOS用来渲染字体风格的机制，它以特定的方式来决定指定范围内的字符串的原始信息，比如字体，颜色，字重，斜体等。


与`UILabel`进行对比的结果如下：
```
- (void)viewDidLoad {
[super viewDidLoad];
NSLog(@"UILabel 开始渲染");
UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
label.center = self.view.center;
[self.view addSubview:label];

label.font = [UIFont systemFontOfSize:15];
label.numberOfLines = 0;
label.textAlignment = NSTextAlignmentJustified;
label.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
NSLog(@"UILabel 结束渲染");
}
```

![UILabel与CATextLayer渲染速度对比](http://upload-images.jianshu.io/upload_images/1687521-45ad3e6d89117043.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到`CATextLayer`消耗的时间反而更长，原因如下：
* 当前运行的模拟器环境大于iOS6.0，所以`UILabel`也已经使用了`CoreText`进行渲染，因为`CATextLayer`在渲染速度方面并没有任何优势。
* 为`CATextLayer`设置字体等属性需要额外创建很多对象，并且需要自己管理内存，这导致了`CATextLayer`的整体速度比现在的`UILabel`要慢。

所以小伙伴们如果不是需要适配到iOS6.0以下的话是可以忽视掉`CATextLayer`的。

###富文本
下面我们来尝试用`CATextLayer`来渲染一个富文本字符串。需要注意的是我们使用了一些`Core Text`中的常量，所以你需要先引入`Core Text`才可以正常编译。

```
- (void)viewDidLoad {
[super viewDidLoad];
NSLog(@"CATextLayer 开始渲染");
CATextLayer *textLayer = [CATextLayer layer];
textLayer.frame = self.labelView.bounds;
textLayer.contentsScale = [UIScreen mainScreen].scale;
[self.labelView.layer addSublayer:textLayer];

textLayer.alignmentMode = kCAAlignmentJustified;
textLayer.wrapped = YES;

UIFont *font = [UIFont systemFontOfSize:15];

NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing  elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar  leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc  elementum, libero ut porttitor dictum, diam odio congue lacus, vel  fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet  lobortis";
//create attributed string
NSMutableAttributedString *string = nil;
string = [[NSMutableAttributedString alloc] initWithString:text];

CFStringRef fontName = (__bridge CFStringRef)font.fontName;
CGFloat fontSize = font.pointSize;
CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);

NSDictionary *attribs = @{
(__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
(__bridge id)kCTFontAttributeName: (__bridge id)fontRef
};

[string setAttributes:attribs range:NSMakeRange(0, [text length])];
attribs = @{
(__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
(__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
(__bridge id)kCTFontAttributeName: (__bridge id)fontRef
};
[string setAttributes:attribs range:NSMakeRange(6, 5)];

CFRelease(fontRef);

textLayer.string = string;
NSLog(@"CATextLayer 结束渲染");
}
```

![CATextLayer渲染富文本字符串](http://upload-images.jianshu.io/upload_images/1687521-6d2cb6f3b90ffdab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

同样的这里也奉上UILabel对应的版本。
```
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
```

###制作一个UILabel的替代品
即使现在的`UILabel`已经完全不逊色于`CATextLayer`了，我们依然可以像书中那样自己用`CATextLayer`制作一个`UILabel`的替代品，虽然用处不大，但是很有趣不是吗。

我们创建一个`UILabel`的子类`LayerLabel`，由于`UILabel`使用的`layer`是内部类 `_UILabelLayer`，所以我们需要使用 `+layerClass`方法来偷偷替换为我们的`CATextLayer`

```
@implementation LayerLabel
+ (Class)layerClass
{
//将默认的layer替换为CATextLayer
return [CATextLayer class];
}

- (CATextLayer *)textLayer
{
return (CATextLayer *)self.layer;
}

- (void)setUp
{
//从label中获取默认的属性
self.text = self.text;
self.textColor = self.textColor;
self.font = self.font;

//按理来说对齐方式也应该使用label中原有的值
//但是那么做有些太过麻烦，所以这里先写死
[self textLayer].alignmentMode = kCAAlignmentJustified;
￼
[self textLayer].wrapped = YES;
[self.layer display];
}

- (id)initWithFrame:(CGRect)frame
{
if (self = [super initWithFrame:frame]) {
[self setUp];
}
return self;
}

- (void)awakeFromNib
{
//让我们的label支持Interface Builder
[self setUp];
}

- (void)setText:(NSString *)text
{
super.text = text;
[self textLayer].string = text;
}

- (void)setTextColor:(UIColor *)textColor
{
super.textColor = textColor;
[self textLayer].foregroundColor = textColor.CGColor;
}

- (void)setFont:(UIFont *)font
{
super.font = font;
CFStringRef fontName = (__bridge CFStringRef)font.fontName;
CGFontRef fontRef = CGFontCreateWithFontName(fontName);
[self textLayer].font = fontRef;
[self textLayer].fontSize = font.pointSize;
￼
CGFontRelease(fontRef);
}
@end
```

##CATransformLayer

CATransformLayer 允许你将3D模型模块化，例如我们接下来要做的，创建一个方块。

```
- (CALayer *)faceWithTransform:(CATransform3D)transform
{
//create cube face layer
CALayer *face = [CALayer layer];
face.frame = CGRectMake(-50, -50, 100, 100);

//apply a random color
CGFloat red = (rand() / (double)INT_MAX);
CGFloat green = (rand() / (double)INT_MAX);
CGFloat blue = (rand() / (double)INT_MAX);
face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;

face.transform = transform;
return face;
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform
{
//create cube layer
CATransformLayer *cube = [CATransformLayer layer];

//add cube face 1
CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
[cube addSublayer:[self faceWithTransform:ct]];

//add cube face 2
ct = CATransform3DMakeTranslation(50, 0, 0);
ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
[cube addSublayer:[self faceWithTransform:ct]];

//add cube face 3
ct = CATransform3DMakeTranslation(0, -50, 0);
ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
[cube addSublayer:[self faceWithTransform:ct]];

//add cube face 4
ct = CATransform3DMakeTranslation(0, 50, 0);
ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
[cube addSublayer:[self faceWithTransform:ct]];

//add cube face 5
ct = CATransform3DMakeTranslation(-50, 0, 0);
ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
[cube addSublayer:[self faceWithTransform:ct]];

//add cube face 6
ct = CATransform3DMakeTranslation(0, 0, -50);
ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
[cube addSublayer:[self faceWithTransform:ct]];

//center the cube layer within the container
CGSize containerSize = self.containerView.bounds.size;
cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);

//apply the transform and return
cube.transform = transform;
return cube;
}
- (void)viewDidLoad {
[super viewDidLoad];

//设置灭点
CATransform3D pt = CATransform3DIdentity;
pt.m34 = -1.0 / 500.0;
self.containerView.layer.sublayerTransform = pt;

//添加方块1
CATransform3D c1t = CATransform3DIdentity;
c1t = CATransform3DTranslate(c1t, -100, 0, 0);
CALayer *cube1 = [self cubeWithTransform:c1t];
[self.containerView.layer addSublayer:cube1];

//添加方块2
CATransform3D c2t = CATransform3DIdentity;
c2t = CATransform3DTranslate(c2t, 100, 0, 0);
c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
CALayer *cube2 = [self cubeWithTransform:c2t];
[self.containerView.layer addSublayer:cube2];
}
```

![](http://upload-images.jianshu.io/upload_images/1687521-690b3c204cf0653c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##小结
这次先介绍了三种专用图层：可以高效绘制不同形状的`CAShapeLayer`，过去用于高效渲染文字的`CATextLayer`以及构造3D组件的`CATransformLayer`。










