#Core Animation 第五章 变换
往期回顾：
[序章](http://www.jianshu.com/p/c4b7b37cf805)
[第一章 - 图层树](http://www.jianshu.com/p/dbf2069cc90b)
[第二章 - 寄宿图](http://www.jianshu.com/p/dae6ccdf3672)
[第三章 - 图层几何](http://www.jianshu.com/p/f12d36b33450)
[第四章 - 视觉效果](http://www.jianshu.com/p/f9130ac64cdd)
[项目中使用的代码](https://github.com/Hoikiiz/CoreAnimationGuideline)

这一章我们主要来研究一下可以用来对图层进行旋转，平移和缩放的`CGAffineTransform` 已经可以将平面图层转换为3D对象的`CATransform3D`。

##仿射变化
------
还记得第三章中我们创建的那个[时钟](https://github.com/Hoikiiz/CoreAnimationGuideline/tree/master/03-图层几何)么，在那里面我们用到了`UIView`的`transform`属性，下面我们来具体说明一下背后的原理，`transform`属性是一个`CGAffineTransform`类型，用于在二维空间做旋转，缩放和平移。`CGAffineTransform`是一个可以和二维空间向量（例如`CGPoint`）做乘法的3X2的矩阵。

![用矩阵表示CGAffineTransform和CGPoint](http://upload-images.jianshu.io/upload_images/1687521-b362c2e5ddfcd4fa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

通过矩阵计算就可以得到新的CGPoint，书中提到虽然CGAffineTransform是3x3的矩阵，即 *以行为主*的格式，但是也会出现三行两列（注意不能使两行三列，那样的话无法与矩阵相乘）也就是*以列为主*的格式。只要能保持一致，哪种格式都是可以的。
四边形中的每一个点都会做出对应的变换，从而得出一个新的四边形。本节标题中仿射的意思是无论矩阵用什么值变换，变换前后保持平行的对边依然保持平行。

###创建CGAffineTransform
`Core Graphics`提供了一系列函数，方便我们即使对矩阵不是很了解也可以轻松地创建变换矩阵，如下几个函数都创建了一个`CGAffineTransform`实例:
```
CGAffineTransformMakeRotation(CGFloat angle)
CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)
```
上面三个方法分别进行了旋转，缩放和平移的变换。下面我们来做一个简单的例子，把一个视图旋转45°。

```
- (IBAction)rotationClick:(id)sender {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    self.layerView.layer.affineTransform = transform;
}
```
这里使用了`CALayer`的属性`affineTransform`，在`UIView`中对应的属性为`transform`。顺便再说一下，`UIView`中与显示相关的属性都是在对`CALayer`中的属性做存取，`UIView`本身不处理显示渲染。
> `M_PI_4` 表示四分之一`π`，`iOS`中变换使用的是弧度而不是度数，所以我们在做旋转的时候应该传入弧度而不是度数，使用下面的宏方便你获取各种角度对应的弧度：
```
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
```

![仿射变换旋转45°后的视图](http://upload-images.jianshu.io/upload_images/1687521-a127dcfb47acd15b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###混合变换
Core Graphics提供了一系列的函数可以在一个变换的基础上做更深层次的变换，比如同时进行缩放和旋转等：
```
CGAffineTransformRotate(CGAffineTransform t, CGFloat angle)
CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
CGAffineTransformTranslate(CGAffineTransform t, CGFloat tx, CGFloat ty)
```
对应的除了进行变换，我们也需要一个空值，原始状态，不进行任何变化呢，`Core Graphics`提供了一个常量
```
CGAffineTransformIdentity
```

最后，混合两个已经存在的变换矩阵使用的方法为：
```
CGAffineTransformConcat(CGAffineTransform t1, CGAffineTransform t2);
```

接下来我们来做一个混合变化，先缩小50%，再旋转30°，最后再向右平移200：

```
- (IBAction)complexChangeClick:(id)sender {
    //创建一个transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    //缩小50%
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    //旋转30°
    transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30.0);
    //平移
    transform = CGAffineTransformTranslate(transform, 200, 0);
    
    self.layerView.layer.affineTransform = transform;
}
```

![混合变换后的视图](http://upload-images.jianshu.io/upload_images/1687521-3414075d70ebb0f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
你可能会发现我们的视图并没有水平的向下平移200的长度，而且还有点向下偏，那是因为在视图旋转的同时，我们平移的方向也被旋转了30°，也就是说先旋转再平移跟先平移再旋转的结果是不同，这也跟矩阵相乘顺序的特性保持一致。

##3D变换
------
因为`CGAffineTransform`属于`Core Graphics`框架，所以这是一个严格意义上的2D变换的框架，我们在第一章也提到过图层的一大特性是可以进行3D变换，也提到过`zPosition`，在这里我们要用得到属性就是`CATransform3D`。


![对一个3D像素点做CATransform3D矩阵变化](http://upload-images.jianshu.io/upload_images/1687521-f8cd77b29b506af9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

和`CGAffineTransform`矩阵类似，`Core Animation`提供了一系列的方法用来创建和组合`CATransform3D`类型的矩阵，和`Core Graphics`的函数类似，但是3D的平移和旋转多处了一个z参数，并且旋转函数除了`angle`之外多出了`x,y,z`三个参数，分别决定了每个坐标轴方向上的旋转：

```
CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz) 
CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
```

如果你对围绕某个轴旋转感到陌生，那么你可以通过下图来了解一下：


![X, Y, Z 轴，已经围绕他们旋转的方向](http://upload-images.jianshu.io/upload_images/1687521-87b274349c50b699.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


可以看出来2D仿射变换中的旋转实际就是在围绕z轴进行旋转。现在我们把视图绕Y轴旋转45°来看一下效果：

```
- (IBAction)YRotationClick:(id)sender {
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform;
    
}
```
![绕Y轴旋转45°的视图](http://upload-images.jianshu.io/upload_images/1687521-d6fcf0942888d167.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

看起来好像我们的视图只是被压缩了一点，这是因为没有透视效果的原因。

###透视投影

虽然`Core Animation`帮我们计算了变化矩阵，但我们依然可以自己修改矩阵来实现自己想要的效果，比如修改`CATransform`的元素`m34`。`m34`元素用于按比例缩小`X`和`Y`的值来计算离视角有多远。


![使用m34元素来做透视](http://upload-images.jianshu.io/upload_images/1687521-4e03358b364eca03.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`m34`的默认值是0，我们可以通过设置`m34`为-1.0 / `d`来应用透视效果，`d`代表了想象中视角相机和屏幕之间的距离，具体的值可以自己把握。

```
- (IBAction)prespectiveRotation:(id)sender {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform;
    
}
```
![具有透视效果的旋转变换](http://upload-images.jianshu.io/upload_images/1687521-ffb9c14681ea1a9c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###灭点
当在透视角度绘图的时候，远离相机视角的物体将会变小变远，当远离到一个极限距离，它们可能就缩成了一个点，于是所有的物体最后都汇聚消失在同一个点。
在现实中，这个点通常是视图的中心，于是为了在应用中创建拟真效果的透视，这个点应该聚在屏幕中点，或者至少是包含所有3D对象的视图中点。

![灭点](http://upload-images.jianshu.io/upload_images/1687521-0035e04c2b74a2d9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
当改变一个图层的`position`，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整`m34`来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的`position`），这样所有的3D图层都共享一个灭点。

###sublayerTransform属性

上文提到了灭点的概念也就是说多个图层的m34的值应该保持一致。CALayer有一个叫做sublayerTransform属性，它也是CATransform3D类型，而且它能够影响到所有的自图层。

```
- (IBAction)vanishClick:(id)sender {
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = perspective;
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.layerView.layer.transform = transform1;
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    self.layerView2.layer.transform = transform2;
}
```

![设置了父视图的m34后进行变换](http://upload-images.jianshu.io/upload_images/1687521-ffe02159195878fd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###背面

我们既然可以在3D场景下旋转图层，那么也可以从*背面*去观察它。如果我们在把角度修改为`M_PI`（180°）而不是当前的`M_PI_4`（45°），那么将会把图层完全旋转一个半圈，于是完全背对了相机视角。

![正面与背面](http://upload-images.jianshu.io/upload_images/1687521-919ce29dff2a37f4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如你所见，图层是双面绘制的，反面显示的是正面的一个镜像图片。
但这并不是一个很好的特性，因为如果图层包含文本或者其他控件，那用户看到这些内容的镜像图片当然会感到困惑。另外也有可能造成资源的浪费：想象用这些图层形成一个不透明的固态立方体，既然永远都看不见这些图层的背面，那为什么浪费`GPU`来绘制它们呢？
`CALayer`有一个叫做`doubleSided`的属性来控制图层的背面是否要被绘制。这是一个`BOOL`类型，默认为`YES`，如果设置为`NO`，那么当图层正面从相机视角消失的时候，它将不会被绘制。

##固体对象
------

上面说了那么多接下来我们来尝试创建一个立方体。

```
#define kSize 200
#define kFontSize 60

@interface CubeViewController ()
@property (strong, nonatomic) NSMutableArray <UIView *> *faces;
@end

@implementation CubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.faces = [NSMutableArray new];
    
    //set up the container sublayer transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = perspective;
    
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    //add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    //add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    UIView *face = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSize, kSize)];
    face.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    face.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:kFontSize weight:10];
    [button setTitleColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1] forState:UIControlStateNormal];
    [button setTitle:@(index + 1).stringValue forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [face addSubview:button];
    [self.view addSubview:face];
    [self.faces addObject:face];
    face.layer.transform = transform;
}
- (void)btnClick:(UIButton *)sender {
    
}

@end
```


![正面朝上的立方体](http://upload-images.jianshu.io/upload_images/1687521-0221d9ede7bd6ea0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这个角度我们看到的是一个方形，接下来我们来换一个角度，在`viewDidLoad`中添加如下代码

```
perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
```

![换一个角度](http://upload-images.jianshu.io/upload_images/1687521-7ba97930ad4c650c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



###光亮和阴影

Core Animation可以显示3D的图层，但是它本身并没有光线的概念，我们这里可以使用GLKit来计算阴影和光线：
```
#define kSize 200
#define kFontSize 60
#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5

@interface CubeViewController ()
@property (strong, nonatomic) NSMutableArray <UIView *> *faces;
@end

@implementation CubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.faces = [NSMutableArray new];
    
    //set up the container sublayer transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.view.layer.sublayerTransform = perspective;
    
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    //add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    //add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    UIView *face = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSize, kSize)];
    face.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    face.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:kFontSize weight:10];
    [button setTitleColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1] forState:UIControlStateNormal];
    [button setTitle:@(index + 1).stringValue forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [face addSubview:button];
    [self.view addSubview:face];
    [self.faces addObject:face];
    face.layer.transform = transform;
    [self applyLightingToFace:face.layer];
}

- (void)applyLightingToFace:(CALayer *)face {
    //添加光线图层
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    //转换transform到矩阵
    //GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = [self matrixFrom3DTransformation:transform];
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    //get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    //get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    //set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;

}

- (GLKMatrix4)matrixFrom3DTransformation:(CATransform3D)transform {
    GLKMatrix4 matrix = GLKMatrix4Make(transform.m11, transform.m12, transform.m13, transform.m14,
                                       transform.m21, transform.m22, transform.m23, transform.m24,
                                       transform.m31, transform.m32, transform.m33, transform.m34,
                                       transform.m41, transform.m42, transform.m43, transform.m44);
    return matrix;
}

- (void)btnClick:(UIButton *)sender {
    
}

@end
```


![动态计算光影效果后的立方体](http://upload-images.jianshu.io/upload_images/1687521-f5d71774f9ca75a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###点击事件
你可能会发现我们明明已经给Button绑定了点击事件，但是却没有触发，实际上是因为4，5，6这三个图层的位置位于1，2，3上面。这里我们设定为除了3以外的face的userInteractionEnabled均为NO。


![响应点击事件](http://upload-images.jianshu.io/upload_images/1687521-a2dee53c9c47b0b0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##总结
-----
这一章主要讲述了仿射变化与3D变换，以及变换背后的原理。








