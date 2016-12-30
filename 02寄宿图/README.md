#Core Animation 第二章 寄宿图 
[序章](http://www.jianshu.com/p/c4b7b37cf805)
[第一章](http://www.jianshu.com/p/dbf2069cc90b)

##contents属性
----------
`contents`是`CALayer`的一个属性，类型为`id`,但如果你用`CGImage`以外的对象对其赋值的话你只能得到一个空的图层。
>`contents`之所以是`id`类型书中的解释为：在`macOS`中，`CGImage`和`NSImage`对象都可以对`contents`属性起作用。

还需要注意的就是`UIImage`的 `CGImage` 属性实际是一个 `CGImageRef`的结构体,所以你需要使用`__bridge`来进行桥接。
```
layer.contents = (__bridge id)image.CGImage;
```
书中提到如果是`MRC`环境下，则不需要`__bridge`，不过现在`MRC`已经成为历史了。

接下来你可以新建一个工程或者继续使用上一章使用的[工程](https://github.com/Hoikiiz/CoreAnimationGuideline)，在根控制器的View中添加一个空白的UIView，作为我们要使用的layerView，设置contents属性。

```
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"pica"];
    self.layerView.layer.contents = (__bridge id)image.CGImage;
}
```

![向UIView的主图层中添加contents.png](http://upload-images.jianshu.io/upload_images/1687521-19baf3974e7adcfe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


这样我们就可以不使用`UIImageView`来显示图片了。顺便一提，如果你使用了`UIImageView`来显示图片的话，你会发现`UIImageView.layer`的`contents`与你赋值的`UIImage`的`CGImage`其实是同一个对象。

![对比UIImageView.png](http://upload-images.jianshu.io/upload_images/1687521-a9ae34378896641d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###contentsGravity
----------
再说这个属性之前，我们先来对我们的皮卡丘做一点小改动，把200x200的layerView变成320x180，再来看一下，会发现我们的皮卡丘被拉伸了。


![被拉伸的皮卡丘.png](http://upload-images.jianshu.io/upload_images/1687521-de582d9aaf4313c3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

属性`UIKit`的我们很快就能想到修改`contentMode`来处理图片的拉伸状态。
```
view.contentMode = UIViewContentModeScaleAspectFit;
```
而在`CALayer`中，这个属性叫做`contentsGravity`，`NSString`类型的变量，而`contentMode`则是一个则是一个对象，这里也可以看出`UIView`对`CALayer`进行了封装。`contentsGravity`可用的`NSString`常量如下：

* kCAGravityCenter
* kCAGravityTop
* kCAGravityBottom
* kCAGravityLeft
* kCAGravityRight
* kCAGravityTopLeft
* kCAGravityTopRight
* kCAGravityBottomLeft
* kCAGravityBottomRight
* kCAGravityResize
* kCAGravityResizeAspect
* kCAGravityResizeAspectFill
与contentMode一样，`contentsGravity`也是处理内容在图层边界的对齐方式，下面我们使用 `kCAGravityResizeAspect`来处理我们的layerView。

```
self.layerView.layer.contentsGravity = kCAGravityResizeAspect;
```

![处理contentsGravity后的皮卡丘.png](http://upload-images.jianshu.io/upload_images/1687521-14d956ce355050da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###contentsScale
----------
`contentsScale`决定了寄宿图的像素尺寸和视图大小的比例，默认值为1.0。关于试图大小，如果你接着使用上面的例子来设置`contentsScale`的话，你会发现`contentsScale`并没有生效，因为我们已经设置了`layer`的边界状态。而且如果你只是想要放大图片的话，我们后面还会说到一个更方便的属性`transform`。
更多的时候我们真正使用到`contentsScale`属性是为了适应Retain屏幕。它用来判断绘制图层时应该为寄宿图创建的空间大小和需要显示的拉伸程度（如果没有设置`contentsGravity`的话），与`UIView`的`contentScaleFactor`属性类似。如果`contentsScale`为1.0则每个点分配一个像素，为2.0则每个点分配两个像素用来绘制图片。由于`contentsGravity`默认值为resize，所以我们需要调整一下`contentsGravity`以方便我们看到实际效果。
```
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"pica"];
    self.layerView.layer.contents = (__bridge id)image.CGImage;
    self.layerView.layer.contentsGravity = kCAGravityCenter;
    self.layerView.layer.contentsScale = image.scale;
}
```

![修改过contentsScale的皮卡丘.png](http://upload-images.jianshu.io/upload_images/1687521-79a053822f9fe258.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


可以看到我们的皮卡丘不但被放大了，而且出现了一些像素化的情况，所以通常使用的时候应该与屏幕的scale对应一致。
```
self.layerView.layer.contentsScale = [UIScreen mainScreen].scale;
```

###maskToBounds
-------
这个属性与UIView 的 clipsToBounds 类似，用来决定是否显示超出边界的内容，设置为YES则不会显示超出部分的内容。我们可以使用刚刚的例子来测试一下。
```
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"pica"];
    self.layerView.layer.contents = (__bridge id)image.CGImage;
    self.layerView.layer.contentsGravity = kCAGravityCenter;
//    self.layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layerView.layer.contentsScale = image.scale;
    self.layerView.layer.masksToBounds = YES;
}
```

![maskToBounds设置为YES的皮卡丘.png](http://upload-images.jianshu.io/upload_images/1687521-568f5fcd5aa1b40a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

contentsRect
-------

`contentsRect`属性允许我们只显示寄宿图的某一个区域。和`bounds`，`frame`不同的是`contentsRect`的单位不是点，而是 0 到 1的一个单位。默认的`contentsRect`是{0,0,1,1}，也就是说整张寄宿图都是可见的，如果我们制定一个小一点的矩形，那么图片就会被剪裁，这里我直接使用书中的图片来解释。

![一个自定义的 contentsRect (左)和之前显示的内容(右).png](http://upload-images.jianshu.io/upload_images/1687521-522ce527e0a3c268.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

下面我们来做一个简单的例子，这是我们的VC：

![StoryBoard中的控制器.png](http://upload-images.jianshu.io/upload_images/1687521-3e2e4eb6f9669a95.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这是我们要使用的图片：

![dribbble.png](http://upload-images.jianshu.io/upload_images/1687521-53407e9abfc1b101.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
```
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
```

效果如下：

![contentsRect效果展示.png](http://upload-images.jianshu.io/upload_images/1687521-3cb562e2cfe068ca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###contentsCenter
-------

首先，`contentsCenter`与位置无关，他是一个`CGRect`类型的属性，定一个一个固定的边框和在图层上可以拉伸的范围。效果与`UIImage`的拉伸方法类似。例如我们将`contentsCenter`设置为{0.25, 0.25, 0.5, 0.5}则图片的拉伸状态如下：

![contentsCenter.png](http://upload-images.jianshu.io/upload_images/1687521-7c8e67c89cad38d7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##Custom Drawing
---------
给`contents`赋值`CGImage`并不是设置寄宿图的唯一途径，我们也可以使用`Core Graphics`直接绘制寄宿图。我们可以通过继承`UIView`并实现`-drawRect:`方法来自定义绘制。当`UIView`检测到`-drawRect:`方法被调用了，就会为视图分配一个寄宿图，这个寄宿图的像素尺寸为视图大小乘以`contentsScale`。也就是说如果你不需要寄宿图，那么你最好不要实现这个方法，那样的话会造成CPU资源和内存的浪费。

>当视图出现在屏幕上的时候`-drawRect:`方法就会被调用，并且绘制的结果会被缓存起来，当开发者调用`-setNeedsDisplay`或者影响视图表现的属性，如bounds时，寄宿图就会被更新。

`-drawRect:`是一个UIView的方法，实际是layer完成了绘制与缓存。当寄宿图需要被重绘的时候CALayer就会请求它的代理给它一个寄宿图来显示。
```
- (void)displayLayer:(CALayer *)layer;
```
如果这个方法没有被实现，CALayer就会尝试下面的方法：
```
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
```

接下来我们来实际绘制一个寄宿图吧。

```
- (void)viewDidLoad {
    [super viewDidLoad];   
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.f, 50.f, 100.f, 100.f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layerView.layer addSublayer:blueLayer];
    [blueLayer display];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}
```


![实现CALayerDelegate来绘制图层.png](http://upload-images.jianshu.io/upload_images/1687521-4522838c989e2e0a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

需要注意的是：
* 我们队blueLayer调用了display方法，这是因为CALayer不会因为被显示到屏幕上就自动重绘。
* 我们并没有设置maskToBounds属性，但是视图依然被剪裁了，这是因为使用CALayerDelegate绘制寄宿图的时候，并没有对边界外绘制提供支持。

##总结
-------
本章主要讲述了 contents，寄宿图相关的属性，以及如何使用CALayerDelegate绘制寄宿图。
