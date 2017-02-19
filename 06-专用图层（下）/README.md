往期回顾：
[序章](http://www.jianshu.com/p/c4b7b37cf805)
[第一章 - 图层树](http://www.jianshu.com/p/dbf2069cc90b)
[第二章 - 寄宿图](http://www.jianshu.com/p/dae6ccdf3672)
[第三章 - 图层几何](http://www.jianshu.com/p/f12d36b33450)
[第四章 - 视觉效果](http://www.jianshu.com/p/f9130ac64cdd)
[第五章 - 变换](http://www.jianshu.com/p/58bcf00b5901)
[第六章 专用图层（上）](http://www.jianshu.com/p/58bcf00b5901)
[项目中使用的代码](https://github.com/Hoikiiz/CoreAnimationGuideline)

##CAGradientLayer

相信大家或多或少的都遇到过渐变过渡背景的需求，这种时候你完全可以选择让设计为你切一个图片背景，但是为什么不尝试自己来绘制一个呢？`CAGradientLayer`就是这样一个用来将颜色平稳过渡的图层。
下面我们先来看一个例子再来解释如何使用`CAGradientLayer`

```
class CAGradientLayerViewController: UIViewController {
@IBOutlet weak var containerView: UIView!
override func viewDidLoad() {
let gradientLayer = CAGradientLayer()
gradientLayer.frame = self.containerView.bounds
self.containerView.layer.addSublayer(gradientLayer)
gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
gradientLayer.startPoint = CGPoint(x: 0, y: 0)
gradientLayer.endPoint = CGPoint(x: 1, y: 1)
}
}
```


![红蓝两色对角线渐变](http://upload-images.jianshu.io/upload_images/1687521-1afb1da4149b50a2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到`CAGradientLayer`的时候方法非常简单，你只需要规定好渐变的起始点`startPoint`，终点`endPoint`已经你希望混合的颜色`colors`，`CoreAnimation`就会平稳的过渡这些颜色。

###非均匀渐变
大家可能已经注意到了，上面两种颜色的过渡是完全均匀的，但是我们也会遇到不完全变换的情况，这种时候我们就需要用到`CAGradientLayer`的另一个属性： `locations`。这个属性用来标记每种颜色变化的范围，locations数组中元素的数量需要跟colors中的属相相同。
![非均匀渐变](http://upload-images.jianshu.io/upload_images/1687521-e4c4d161e5dce07b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
override func viewDidLoad() {
let gradientLayer = CAGradientLayer()
gradientLayer.frame = self.containerView.bounds
gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
gradientLayer.locations = [0.0, 0.25, 0.5]
gradientLayer.startPoint = CGPoint(x: 0, y: 0)
gradientLayer.endPoint = CGPoint(x: 1, y: 1)
self.containerView.layer.addSublayer(gradientLayer)
}
```

##CAReplicatorLayer
重复图层，跟他的名字一样，这个图层主要用来高效的生成许多相思的图层。`CAReplicatorLayer`在使用的时候需要指定一个`instanceCount`（指定这个图层需要重复多少次）以及一个`instanceTransform`（指定每次重复的时候相对于上一次的3D变化效果），下面简单写一个例子。

```
override func viewDidLoad() {
super.viewDidLoad()
let replicatorLayer = CAReplicatorLayer()
replicatorLayer.frame = containerView.bounds
self.containerView.layer.addSublayer(replicatorLayer)
replicatorLayer.instanceCount = 10
var transform = CATransform3DIdentity
transform = CATransform3DTranslate(transform, 0, 200, 0)
transform = CATransform3DRotate(transform, CGFloat(M_PI / 5.0), 0, 0, 1)
transform = CATransform3DTranslate(transform, 0, -200, 0)
replicatorLayer.instanceTransform = transform
replicatorLayer.instanceBlueOffset = -0.1
replicatorLayer.instanceGreenOffset = -0.1
let layer = CALayer()
layer.frame = replicatorLayer.bounds
layer.backgroundColor = UIColor.white.cgColor
replicatorLayer.addSublayer(layer)
}
```

![重复图层示例](http://upload-images.jianshu.io/upload_images/1687521-0fe75a2d65aa898d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##CAScrollLayer
我们都知道，当我们想要找的的内容超出了视图的`bounds`的时候，我们可以使用`UIScrollView`以及他的子类`UITableView`或者`UICollectionView`来实现滚动展示。当然，`CoreAnimation`也有对应的图层，那就是`CAScrollLayer`。不过因为他是一个图层，所以`CAScrollLayer`并不能处理用户的触摸事件并把它转化为滚动事件，自然也不会自己为你处理类似`UIScrollView`的`Decelerating`效果以及反弹效果。如果你想使用`CAScrollLayer`代替`UISCrollView`，那么你需要通过UIView来处理用户的手势，然后将它体现在`CAScrollLayer`上面，而且你还需要处理代理等相关信息，所以说就滚动视图而言`CAScrollLayer`并不能算得上是一个明确的选择。

##CATiledLayer
我们常用的加载图片的方式是 `UIImage`的`-imageNamed:`或者`imageWithContentsOfFile:`方法，但是这些方法会阻塞主线程，所以在你加载大图的时候你的app可能会出现卡顿，而且如果图片过大还会出现其他的问题，下面引用作者的原话：
>所有显示在屏幕上的图片最终都会被转化为OpenGL纹理，同时OpenGL有一个最大的纹理尺寸（通常是2048x2048，或4096x4096，这个取决于设备型号）。如果你想在单个纹理中显示一个比这大的图，即便图片已经存在于内存中了，你仍然会遇到很大的性能问题，因为Core Animation强制用CPU处理图片而不是更快的GPU。

而CATiledLayer则可以将大图转换为若干小图，然后将他们单独按需加载（瓦片图）。
下面我们先写一个简单的例子将一张4096x4096的皮卡丘分割为若干小图。
```swift
let argv = ProcessInfo.processInfo.arguments
guard argv.count >= 2 else {
assertionFailure("TileCutter arguments: inputfile")
exit(-1)
}

let inputFile = String.init(cString: argv[1], encoding: String.Encoding.utf8)! as NSString

let titleSize: CGFloat = 256.0

let outputPath = inputFile.deletingPathExtension

let image: NSImage = NSImage(contentsOfFile: inputFile as String)!
var size = image.size
let representations = image.representations
if !representations.isEmpty {
let representation = representations[0]
size.width = CGFloat(representation.pixelsWide)
size.height = CGFloat(representation.pixelsHigh)
}
var rect = NSRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
let imageRef = image.cgImage(forProposedRect: &rect, context: nil, hints: nil)

let rows = Int(ceil(size.height / titleSize))
let cols = Int(ceil(size.width / titleSize))

for y in 0..<rows {
for x in 0..<cols {
let titleRect = CGRect(x: CGFloat(x)*titleSize, y: CGFloat(y)*titleSize, width: titleSize, height: titleSize)
let titleImage = imageRef!.cropping(to: titleRect)

let imageRep = NSBitmapImageRep(cgImage: titleImage!)
let data = imageRep.representation(using: NSJPEGFileType, properties: [:])
let path = outputPath.appendingFormat("_%02i_%02i.jpg", x, y)
let fileURL = URL(fileURLWithPath: path)
do {
try data?.write(to: fileURL)
} catch _ {}
}
}
```
运行这个swift的脚本的时候记得在命令行追加自己的图片路径，或者在Xcode中追加scheme参数

![修改Edit Scheme](http://upload-images.jianshu.io/upload_images/1687521-b628299619c08679.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



接下来回到我们的CATiledLayer。CATiledLayer可以很好的ScrollView结合在一起。
```swift
class CATiledLayerViewController: UIViewController, CALayerDelegate {
@IBOutlet weak var scrollView: UIScrollView!

override func viewDidLoad() {
super.viewDidLoad()
let tiledLayer = CATiledLayer()
tiledLayer.frame = CGRect(x: 0, y: 0, width: 4096, height: 4096)
tiledLayer.delegate = self
scrollView.layer.addSublayer(tiledLayer)
scrollView.contentSize = tiledLayer.frame.size
tiledLayer.setNeedsDisplay()
tiledLayer.contentsScale = UIScreen.main.scale
}

func draw(_ layer: CALayer, in ctx: CGContext) {
let tileLayer = layer as! CATiledLayer
let bounds = ctx.boundingBoxOfClipPath
let scale = UIScreen.main.scale
let x = Int(floor(bounds.origin.x / tileLayer.tileSize.width * scale))
let y = Int(floor(bounds.origin.y / tileLayer.tileSize.height * scale))
let imageName = String.init(format: "pica_big_%02i_%02i", x, y)
let imagePath = Bundle.main.path(forResource: imageName, ofType: "jpg")
let tileImage = UIImage(contentsOfFile: imagePath!)
UIGraphicsPushContext(ctx)
tileImage?.draw(in: bounds)
UIGraphicsPopContext()
}
}
```

![](http://upload-images.jianshu.io/upload_images/1687521-a4052a7079b88ae2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##CAEmitterLayer
`CAEmitterLayer`是在iOS5.0中引入的一个高性能的粒子引擎。`CAEmitterLayer`可以看做是许多`CAEmitterCell`的容器。下面我们来写一个简单的例子，由于属性`EmitterLayer`和`EmitterCell`的属性很多，所以这里不再一一赘述，大家可以再文档中查阅。

```swift
override func viewDidLoad() {
super.viewDidLoad()
let emitter = CAEmitterLayer()
emitter.frame = containerView.bounds
containerView.layer.addSublayer(emitter)

emitter.renderMode = kCAEmitterLayerAdditive
emitter.emitterPosition = CGPoint(x: emitter.frame.size.width / 2.0, y: emitter.frame.size.height / 2.0)

let cell = CAEmitterCell()
cell.contents = UIImage(named: "Sparkle")?.cgImage
cell.birthRate = 150
cell.lifetime = 5.0
cell.alphaSpeed = -0.3
cell.velocity = 50
cell.velocityRange = 50
cell.emissionRange = CGFloat(M_PI) * 2.0
emitter.emitterCells = [cell]
}
```

![](http://upload-images.jianshu.io/upload_images/1687521-aa000a11646d9af6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##小结
书中在后面还提到了CAEAGLLayer和AVPlayerLayer，前者为GLKView中的专用图层，由于本人对于OpenGL了解甚少，所以不再赘述，如果大家感兴趣的话我在单独整理一次，后者虽然是CALyaer的子类但是并不属于CoreAnimation框架所以这里也先跳过了。
另注：本次将原书中的代码转换为了swift，所以也欢迎大家对swift方面多多指教。
