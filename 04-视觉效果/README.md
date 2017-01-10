#Core Animation 第四章 视觉效果
往期回顾：
[序章](http://www.jianshu.com/p/c4b7b37cf805)
[第一章 - 图层树](http://www.jianshu.com/p/dbf2069cc90b)
[第二章 - 寄宿图](http://www.jianshu.com/p/dae6ccdf3672)
[第三章 - 图层几何](http://www.jianshu.com/p/f12d36b33450)
[项目中使用的代码](https://github.com/Hoikiiz/CoreAnimationGuideline)

在这一章我们主要会讨论一些通过`CALayer`属性实现的视觉效果。

##圆角
-------
`CALayer`有一个叫做`cornerRadius`的属性，他可以帮助我们不借助PS等工具轻松的搞定圆角矩形，这个属性调整的是图层角的曲率或者说是圆角半径，默认为0，也就是直角，而且曲率值只会影响背景颜色，而不会影响背景图片或者子图层。不过将`masksToBounds`为YES的话，图层里面所有的东西都会被截取。下面来做一个简单的例子。


![两个白色的大视图，里面都包含了一个红色的小视图.png](http://upload-images.jianshu.io/upload_images/1687521-2914274dd8c39555.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 在书中这里提到使用IB(Interface Builder)构建视图的时候IB编辑界面会自动剪裁掉超出子视图的部分，不过这个现象在新的XCode中已经不会出现了。

然后我们设置两个白色视图的圆角半径为 20，并且对第二个白色视图设置`masksToBounds`为YES，来看一下效果。

```
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView1;
@property (weak, nonatomic) IBOutlet UIView *layerView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置圆角半径
    self.layerView1.layer.cornerRadius = 20.0f;
    self.layerView2.layer.cornerRadius = 20.0f;
    
    //设置自动剪裁
    self.layerView2.layer.masksToBounds = YES;
}

@end
```

![设置过圆角后的两个白色视图.png](http://upload-images.jianshu.io/upload_images/1687521-3d16599275a025b9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到两个白色视图都表现出了圆角，但是只有第二个设置了masksToBounds的白色视图剪裁掉了子视图。

##图层边框
-------
`CALayer`另外连个常用的属性就是`borderWidth` 和 `borderColor`，两个共同定义了图层边缘的绘制样式，这条线(`stroke`)沿着图层的`bounds`绘制，同时也包含图层的角。其中 `borderWidth` 默认为0， `borderColor` 默认为黑色。

* `borderColor`为`CGColorRef`类型，由于他不是`Cocoa`的内置对象，所以即便`CGColorRef`的属性是强引用也只能通过`assign`关键字来声明
* 边框是绘制在图层内部的，而且在所有的子图层之前。

下面我们来为白色视图添加边框

```Objective-C
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置圆角半径
    self.layerView1.layer.cornerRadius = 20.0f;
    self.layerView2.layer.cornerRadius = 20.0f;
    
    //设置边框
    self.layerView1.layer.borderWidth = 5.0f;
    self.layerView2.layer.borderWidth = 5.0f;
    
    //设置自动剪裁
    self.layerView2.layer.masksToBounds = YES;
    
}
```

![为图层添加边框.png](http://upload-images.jianshu.io/upload_images/1687521-233ab39f3ddfc844.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 可以看到边框并不会计算自图层的位置和形状而只是沿着图层的边界来绘制。


![边框并不会根据图层里面的内容变化.png](http://upload-images.jianshu.io/upload_images/1687521-a7c18609a8c84018.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##阴影
-------
阴影是以前iOS中十分常用的一种设计，用来突出图层的优先级，或者装饰图层，不过随着扁平化的盛行，阴影已经慢慢的被人们所抛弃了。
`shadowOpacity`属性负责控制阴影的显示，值在0.0 ~ 1.0之间，0.0为阴影不可见，1.0为完全不透明，此外CALayer还有三个属性来协助表现阴影的样子：`shadowColor`, `shadowOffset`, `shadowRadius`。
`shadowColor` 控制阴影的颜色，也是一个CGColorRef类型的属性，`shadowOffset`控制阴影的位置，是一个CGSize类型的值，默认为{0, -3}即阴影默认Y轴向上偏移三个单位。关于这个默认值书中的解释为：
>尽管Core Animation是从图层套装演变而来(可以 认为是为iOS创建的私有动画框架),但是呢,它却是在Mac OS上面世的,前面有 提到,二者的Y轴是颠倒的。这就导致了默认的3个点位移的阴影是向上的。在Mac 上, shadowOffset 的默认阴影向下的,这样你就能理解为什么iOS上的阴影方向是向上的了。

`shadowRadius`用来控制阴影的模糊程度，值越大，阴影越模糊。

![低shadowRadius 与 高shadowRadius](http://upload-images.jianshu.io/upload_images/1687521-5234caac4ca61a36.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###阴影剪裁
与边框不容，阴影是可以继承图层内容的形状的，包括子视图和寄宿图的形状。

![阴影会自动计算寄宿图的形状](http://upload-images.jianshu.io/upload_images/1687521-679fa252c58abd74.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

结合上面说的内容会出现一个问题，那就是我们设置了阴影的同时打开了`masksToBounds`。
```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置圆角半径
    self.layerView1.layer.cornerRadius = 20.0f;
    self.layerView2.layer.cornerRadius = 20.0f;
    
    //设置边框
    self.layerView1.layer.borderWidth = 5.0f;
    self.layerView2.layer.borderWidth = 5.0f;
    
    //设置剪裁
    self.layerView2.layer.masksToBounds = YES;
    
    //设置阴影
    self.layerView1.layer.shadowOpacity = 0.8f;
    self.layerView2.layer.shadowOpacity = 0.8f;
    
    self.layerView1.layer.shadowOffset = CGSizeMake(0, 3);
    self.layerView2.layer.shadowOffset = CGSizeMake(0, 3);
    
    self.layerView1.layer.shadowRadius = 5.0f;
    self.layerView2.layer.shadowRadius = 5.0f;
}
```

![阴影被masksToBounds剪裁掉了](http://upload-images.jianshu.io/upload_images/1687521-0479eae93e0bbac6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果我们既需要`masksToBounds`同时也想要一个印象效果的话，可以通过一个比较tricky的方法来实现，也就是在当前视图的下面添加一个同样大小的透明视图，使用它来显示阴影。
![当前图层树的结构](http://upload-images.jianshu.io/upload_images/1687521-8c18821e6e9529b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
```
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView1;
@property (weak, nonatomic) IBOutlet UIView *layerView2;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置圆角半径
    self.layerView1.layer.cornerRadius = 20.0f;
    self.layerView2.layer.cornerRadius = 20.0f;
    
    //设置边框
    self.layerView1.layer.borderWidth = 5.0f;
    self.layerView2.layer.borderWidth = 5.0f;
    
    //设置剪裁
    self.layerView2.layer.masksToBounds = YES;
    
    //设置阴影
    self.shadowView.layer.shadowOpacity = 0.8f;
    self.layerView2.layer.shadowOpacity = 0.8f;
    
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 3);
    self.layerView2.layer.shadowOffset = CGSizeMake(0, 3);
    
    self.shadowView.layer.shadowRadius = 5.0f;
    self.layerView2.layer.shadowRadius = 5.0f;
}

@end
```


![同时拥有masksToBounds和阴影](http://upload-images.jianshu.io/upload_images/1687521-d2c300146cf81a1e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###shadowPath
上面已经提到过阴影会自动计算自图层和寄宿图的形状，但是当自图层很多的时候，这种计算必然会十分消耗性能，所以如果你知道当前图层需要的阴影的形状，可以使用`shadowPath`传入一个`CGPathRef`类型的值来进行优化。


```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layerView1.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"pica"].CGImage);
    self.layerView2.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"pica"].CGImage);
    
    //显示阴影
    self.layerView1.layer.shadowOpacity = 0.8f;
    self.layerView2.layer.shadowOpacity = 0.8f;
    
    //绘制一个矩形阴影
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddRect(squarePath, NULL, self.layerView1.bounds);
    self.layerView1.layer.shadowPath = squarePath;
    CGPathRelease(squarePath);
    //绘制一个圆形阴影
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.layerView2.bounds);
    self.layerView2.layer.shadowPath = circlePath;
    CGPathRelease(circlePath);
}
```

![使用shadowPath自己绘制阴影形状](http://upload-images.jianshu.io/upload_images/1687521-50e74c7d6070d017.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 这里使用了`CGMutablePathRef`来进行绘制，由于`CGMutablePathRef`并不是一个Cocoa对象，所以需要使用`CGPathRelease`进行手动释放，如果使用`UIKit`中提供的`UIBezierPath`进行操作则不需要手动释放。

##图层蒙版
-------
有些时候我们需要一个不规则的容器来展现我们需要的内容，比如,你想展示一个有星形框架的图片,又或者想让一些古卷文字慢慢渐变成背景色,而不是一个突兀的边界。
CALayer中有一个属性叫做mask。这个属性本身也是CALayer类型，类似于子图层，与子图层不同的是mask定义了父图层可以显示的区域，可以脑补一下 *神奇宝贝* 里面 *我是谁* 的那个过场。效果如下：

![使用mask制作一个红色的皮卡丘.png](http://upload-images.jianshu.io/upload_images/1687521-3986ba92e2e8bc18.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
@interface MaskViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView1;
@property (weak, nonatomic) IBOutlet UIView *layerView2;
@property (weak, nonatomic) IBOutlet UIView *layerView3;

@end

@implementation MaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *redImage = [UIImage imageNamed:@"redImage"];
    UIImage *pica = [UIImage imageNamed:@"pica"];
    self.layerView1.layer.contents = (__bridge id)redImage.CGImage;
    self.layerView2.layer.contents = (__bridge id)pica.CGImage;
    
//设置蒙版
    self.layerView3.layer.contents = self.layerView1.layer.contents;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.layerView3.bounds;
    maskLayer.contents = self.layerView2.layer.contents;
    self.layerView3.layer.mask = maskLayer;
}

@end
```
而且蒙版真正强大的地方在于蒙版是可以通过代码或者动画来生成的，而不是局限于静态的图片。

##拉伸过滤
-------
这块我之前没有什么积累，就都直接引用作者的原话好了，不过代码示例我会为大家准备好的。
接下来要说的两个属性分别是`minificationFilter`和 `magnificationFilter`。总得来讲,当我们视图显示一个图片的时候,都应该正确地显示这个图片(意即:以 正确的比例和正确的1:1像素显示在屏幕上)。原因如下:
* 能够显示最好的画质,像素既没有被压缩也没有被拉伸。 
* 能更好的使用内存,因为这就是所有你要存储的东西。 
* 最好的性能表现,CPU不需要为此额外的计算。

但很多时候图片的大小并不能很好的和视图的大小保持一致，这个时候有一种叫做拉伸过滤的算法就起到作用了。它作用于原图的像素上并根据需要生成新的像素显示在屏幕上。`CALayer` 为此提供了三种拉伸过滤方法,他们是:
* kCAFilterLinear
* kCAFilterNearest
* kCAFilterTrilinear
`minification`(缩小图片)和`magnification`(放大图片)默认的过滤器都是 kCAFilterLinear ,这个过滤器采用双线性滤波算法,它在大多数情况下都表现良好。双线性滤波算法通过对多个像素取样最终生成新的值,得到一个平滑的表现不错的拉伸。但是当放大倍数比较大的时候图片就模糊不清了。
`kCAFilterTrilinear` 和 `kCAFilterLinear` 非常相似,大部分情况下二者都看不出来有什么差别。但是,较双线性滤波算法而言,三线性滤波算法存储了多个大小情况下的图片(也叫多重贴图),并三维取样,同时结合大图和小图的存储进而得到最后的结果。
这个方法的好处在于算法能够从一系列已经接近于最终大小的图片中得到想要的结果,也就是说不要对很多像素同步取样。这不仅提高了性能,也避免了小概率因舍入错误引起的取样失灵的问题。


![对于大图来说,双线性滤波和三线性滤波表现得更出色](http://upload-images.jianshu.io/upload_images/1687521-4ace01a1ca2c9f6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`kCAFilterNearest` 是一种比较武断的方法。从名字不难看出,这个算法(也叫最近过滤)就是取样最近的单像素点而不管其他的颜色。这样做非常快,也不会使图片模糊。但是,最明显的效果就是,会使得压缩图片更糟,图片放大之后也显得块状或是马赛克严重。

![对于没有斜线的小图来说,最近过滤算法要好很多](http://upload-images.jianshu.io/upload_images/1687521-75d35c783966500d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
总的来说,对于比较小的图或者是差异特别明显,极少斜线的大图,最近过滤算法会保留这种差异明显的特质以呈现更好的结果。但是对于大多数的图尤其是有很多斜线或是曲线轮廓的图片来说,最近过滤算法会导致更差的结果。换句话说,线性过滤保留了形状,最近过滤则保留了像素的差异。

下面来做一个简单的小时钟，

```
@interface FilterViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *digitViews;
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad]; //get spritesheet image
    UIImage *digits = [UIImage imageNamed:@"numbers"];
    
    //set up digit views
    for (UIView *view in self.digitViews) {
        //set contents
        view.layer.contents = (__bridge id)digits.CGImage;
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        view.layer.contentsGravity = kCAGravityResizeAspect;
    }
    
    //start timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    //set initial clock time
    [self tick];
}

- (void)setDigit:(NSInteger)digit forView:(UIView *)view
{
    //adjust contentsRect to select correct digit
    view.layer.contentsRect = CGRectMake(digit * 0.1, 0, 0.1, 1.0);
}

- (void)tick
{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
    //set hours
    [self setDigit:components.hour / 10 forView:self.digitViews[0]];
    [self setDigit:components.hour % 10 forView:self.digitViews[1]];
    
    //set minutes
    [self setDigit:components.minute / 10 forView:self.digitViews[2]];
    [self setDigit:components.minute % 10 forView:self.digitViews[3]];
    
    //set seconds
    [self setDigit:components.second / 10 forView:self.digitViews[4]];
    [self setDigit:components.second % 10 forView:self.digitViews[5]];
}

@end
```

![一个模糊的时钟，由默认的kCAFilterLinear引起](http://upload-images.jianshu.io/upload_images/1687521-6cae7e4cce15f819.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

作为修改，我们在for循环中加入以下代码
```
view.layer.magnificationFilter = kCAFilterNearest;
```


![修改了magnificationFilter后的时钟](http://upload-images.jianshu.io/upload_images/1687521-3b65bd461809ddb3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##组透明
-------
`UIView`中用来处理透明度的属性叫`alpha`，CALayer中对应的属性为`opacity`，这两个属性都会对子层级产生影响，也就是说你给一个图层设置了`opacity`，他说有的子图层的`opacity`都会受到影响。下面的图片中是一个白色的视图内部有一个白色的Label，右边的视图被设置了50%的透明度。

![右边子视图的label被显示了出来](http://upload-images.jianshu.io/upload_images/1687521-92f4488f717a7e1d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


这是由透明度的混合叠加造成的，当你显示一个50%透明度的图层时，图层的每个像素都会一半显示自己的颜色，另一半显示图层下面的颜色。这是正常的透明度的表现。但是如果图层包含一个同样显示50%透明的子图层时，你所看到的视图，50%来自子视图，25%来了图层本身的颜色，另外的25%则来自背景色。
* 书中提到了可以将`info.plist`中的`UIViewGroupOpacity`设置为`YES`来达到整个图层树保持相同透明度的效果，但是当前版本的`Xcode`中`UIViewGroupOpacity`已经默认设置为了`YES`，所以想出现上图中的效果需要先将`UIViewGroupOpacity`设置为`NO`。`UIViewGroupOpacity`的缺点在于他是一个整体配置，整个应用可能会受到不良影响。

除了`UIViewGroupOpacity`，另一个方法就是启用`CALayer`的`shouldRasterize`属性来组透明效果。为了启用`shouldRasterize`属性，我们设置了图层的`rasterizationScale`属性。默认情况下，所有图层拉伸都是1.0， 所以如果你使用了`shouldRasterize`属性，你就要确保你设置了`rasterizationScale`属性去匹配屏幕，以防止出现Retina屏幕像素化的问题。

![修复后的Label](http://upload-images.jianshu.io/upload_images/1687521-5b3d2d5183f30514.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.layerView.alpha = 0.5f;
    self.layerView.layer.shouldRasterize = YES;
    self.layerView.layer.rasterizationScale = [UIScreen mainScreen].scale;
}
```

##总结
-------
这一章介绍了一些可以通过代码应用到图层上的视觉效果,比如圆角,阴影和蒙板。我们也了解了拉伸过滤器和组透明。
在第五章,『变换』中,我们将会研究图层变化和3D转换。














