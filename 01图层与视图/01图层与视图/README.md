#Core Animation 第一章 图层树
[序章](http://www.jianshu.com/p/c4b7b37cf805)
##图层(Layer)与视图(View)
###视图
视图是大家比较熟悉，也是经常接触到的，书中的原意为：
>一个视图就是屏幕上显示的一个矩形块，它能够拦截鼠标点击或者触摸手势等用户输入。视图在层级关系中可以相互嵌套。

iOS开发中的视图为UIView及其子类，`UIView`可以处理触摸时间，支持`Core Graphics`绘图，进行仿射变换（`CGAffineTransform`）等。

###图层
CALayer的功能与UIView基本类似，只不过CALayer不处理用户的交互，需要注意的是CALayer只是不处理，即不关心响应链，但CALayer依旧提供了判断触点位置的方法。

###层级关系
每一个`UIView`都有一个`CALayer`的实例(`backing layer`)，这个实例由`UIView`创建和管理。这个layer才是真正用来在屏幕上显示和做动画的，而UIView则是对CALayer进行了封装，提供了处理触摸的功能，已经CoreAnimation底层方法的高级接口。
##图层的能力
上面说过UIView封装了许多`CoreAnimation`中的底层方法，但CALayer依然有很多功能是UIView中没有涉及到的：
* 阴影，圆角，边框
* 3D变换
* 非矩形范围
* 多级非线性动画

具体的内容会在后面意义讲述。

##使用图层
我们来创建一个[工程](https://github.com/Hoikiiz/CoreAnimationGuideline)，在屏幕中央添加一个UIView（200 x 200）作为我们接下来要使用的View，命名为layerView。



![普通的白色视图.png](http://upload-images.jianshu.io/upload_images/1687521-926fa0ba4548ed07.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


然后我们在这个白色的view上面添加一个小的蓝色图层。书中提到这里需要导入QuartzCore.framework，不过现在大家已经不需要再单独添加了[笑]。
```objective-c
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    //添加子图层
    [self.layerView.layer addSublayer:blueLayer];
}
@end
```
效果如下：

![百色视图内嵌蓝色图层.png](http://upload-images.jianshu.io/upload_images/1687521-706382022126ba92.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

使用图层关联的视图而不是`CALayer`的好处在于，你能在使用所有`CALayer`底层特性的同事，也可以使用`UIView`的高级API。然而，当满足一下条件时，你可能更需要使用`CALayer`:
* 开发同时可以再macOS上运行的跨平台应用
*使用多种`CALayer`的子类
* 性能调优
不过总的来说，处理视图比单独处理图层更加方便。
