
本章开始将正式进入动画的部分，首先要介绍的是隐式动画。所谓隐式动画就是由系统自动完成的动画。

##事务
`Core Animation`基于一个假设,说屏幕上的任何东西都可以(或者可能)做动画。 动画并不需要你在`Core Animation`中手动打开,相反需要明确地关闭,否则他会一 直存在。例如下面的例子，在改变`CALayer`背景色的时候它会自己从旧值平滑的过渡到新值。

```swift
class TransactionViewController: UIViewController {
@IBOutlet weak var layerView: UIView!
weak var colorLayer: CALayer!
override func viewDidLoad() {
super.viewDidLoad()
let layer = CALayer()
self.layerView.layer.addSublayer(layer)
layer.frame = CGRect(x: 35, y: 20, width: 180, height: 180)
layer.backgroundColor = UIColor.blue.cgColor;
colorLayer = layer
}

@IBAction func changeBtnClick(_ sender: UIButton) {
let red = CGFloat(arc4random() % 256) / 255.0
let green = CGFloat(arc4random() % 256) / 255.0
let blue = CGFloat(arc4random() % 256) / 255.0
colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
}
}
```

![默认颜色渐变](http://upload-images.jianshu.io/upload_images/1687521-85769cf0889adee9.gif?imageMogr2/auto-orient/strip)

这个就是一个隐式动画，我们没有指定动画类型，只是改变了一个属性，然后由系统来自动完成动画效果。
那么这些又跟事务有什么关系呢？iOS中的事务可以理解为一系列动画的集合，任何用指定事 务去改变可以做动画的图层属性都不会立刻发生变化,而是当事务一旦提交的时候 开始用一个动画过渡到新值。

事务是通过 `CATransaction` 类来做管理。`CATransaction` 是在图层树改变的时候在一个没有活跃事务的线程中由`CoreAnimation`自动创建的，并且在run-loop重复的时候自动提交。`CATransaction` 没有属性或者实例方法,不需要使用者来单独创建。但是可以用 `begin()` 和 `commit()` 分别来入栈或者出栈。

任何可以做动画的图层属性都会被添加到栈顶的事务,你可以通
过 `setAnimationDuration(_:)` 来设置或者通过 `animationDuration()` 来获取 当前动画的时间（默认值为0.25）

接下来我们来让上面例子中颜色的改变慢一点。

```swift
@IBAction func changeBtnClick(_ sender: UIButton) {
//开始事务
CATransaction.begin()
defer {
//提交事务
CATransaction.commit()
}
CATransaction.setAnimationDuration(1.0)
let red = CGFloat(arc4random() % 256) / 255.0
let green = CGFloat(arc4random() % 256) / 255.0
let blue = CGFloat(arc4random() % 256) / 255.0
colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
}
```

![使用事务来控制动画的时间](http://upload-images.jianshu.io/upload_images/1687521-740b3810e40df9a9.gif?imageMogr2/auto-orient/strip)

当然UIView中也有对应的方法 `beginAnimations(_ : , context: )` ， `commitAnimations()` 等方法。当然最常用的还是 UIView中基于闭包的动画方法：`animate(withDuration: , animations:)`

##完成块
上面提到了 `UIView` 中常用的使用闭包来处理动画的方式，而且还有有一个 `completion` 的闭包来表示动画已经执行结束（完成块）。`CATranscation` 中也有对应的方法 `setCompletionBlock()` 作为动画完成后的回调。下面我们来让方块每次改变颜色后都旋转90°。

```swift
@IBAction func changeBtnClick(_ sender: UIButton) {
//开始事务
CATransaction.begin()
defer {
//提交事务
CATransaction.commit()
}
CATransaction.setAnimationDuration(1.0)
CATransaction.setCompletionBlock { 
var transform = self.colorLayer.affineTransform()
transform = transform.rotated(by: CGFloat(M_PI_2))
self.colorLayer.setAffineTransform(transform)
}
let red = CGFloat(arc4random() % 256) / 255.0
let green = CGFloat(arc4random() % 256) / 255.0
let blue = CGFloat(arc4random() % 256) / 255.0
colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
}
```

![使用完成块旋转图层](http://upload-images.jianshu.io/upload_images/1687521-c8ea042ade0de383.gif?imageMogr2/auto-orient/strip)



##图层行为
处于好奇，你可能会尝试打开事务之后直接对视图，也就是对`UIView`设置背景颜色。然后你就会发现视图的背景颜色是瞬间改变的，并没有渐变的过程。原因也很简单，隐式动画被`UIView`禁用掉了。
之前也提到过，`UIView`显示的内容实际都是它内部的关联图层上的内容，那么`UIView`是怎么禁用掉内部图层的隐式动画的呢？当我们改变图层属性的时候，它会调用 `action(forKey:)` 方法。关于 `action(forKey:)` 的调用我们可以在CALayer的头文件中找到说明：

![](http://upload-images.jianshu.io/upload_images/1687521-1bf1996c28e187ef.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 首先查看代理是否实现了 `action(for layer: CALayer, forKey event: String) ` 如果实现了则调用并返回结果
* 如果没有代理或者代理未实现该方法，那么图层接着会检查包含属性名称对应行为的 `action` 字典
* 如果 `action`中没有包含的属性，那么会继续在图层的`style`字典中查找属性名
* 如果 `style` 中也没有查找到的话，图层会直接调用 `defaultActionForKey()`方法，返回一个标准行为。

结果也就很明显了，`UIView`为继承了代理，并且如果当前`View`不在动画块内的话，`action(forKey:)` 方法就返回`nil`。

```swift
override func viewDidLoad() {
super.viewDidLoad()
print("Outside: \(layerView .action(for: self.layerView.layer, forKey: "backgroundColor"))")
UIView.beginAnimations(nil, context: nil)
print("Inside: \(layerView .action(for: self.layerView.layer, forKey: "backgroundColor"))")
UIView.commitAnimations();
}
```

![视图开启事务与未开启事务 actionForKey 结果对比](http://upload-images.jianshu.io/upload_images/1687521-0d489d9378645017.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


当然我们也可以通过 `CATransaction` 来禁用动画,在 `CATransaction.begin()` 之后调用

```swift
CATransaction.setDisableActions(true)
```

铺垫了这么多，接下来我们尝试通过为`colorLayer`定义一个`action`字典来实现自定义图层行为，例如我们希望新的颜色不是渐变的，而是从左侧划入的。

```swift
class TransactionViewController: UIViewController {
@IBOutlet weak var layerView: UIView!
weak var colorLayer: CALayer!
override func viewDidLoad() {
super.viewDidLoad()
let layer = CALayer()
self.layerView.layer.addSublayer(layer)
layer.frame = CGRect(x: 35, y: 20, width: 180, height: 180)
layer.backgroundColor = UIColor.clear.cgColor;
let transition = CATransition()
transition.type = kCATransitionPush
transition.subtype = kCATransitionFromLeft
layer.actions = ["backgroundColor": transition]
colorLayer = layer
}

@IBAction func changeBtnClick(_ sender: UIButton) {
//开始事务
CATransaction.begin()
defer {
//提交事务
CATransaction.commit()
}
CATransaction.setAnimationDuration(1.0)
CATransaction.setCompletionBlock { 
var transform = self.colorLayer.affineTransform()
transform = transform.rotated(by: CGFloat(M_PI_2))
self.colorLayer.setAffineTransform(transform)
}
let red = CGFloat(arc4random() % 256) / 255.0
let green = CGFloat(arc4random() % 256) / 255.0
let blue = CGFloat(arc4random() % 256) / 255.0
colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
}
}
```

![自定义图层背景颜色行为](http://upload-images.jianshu.io/upload_images/1687521-b3e13a44074cf258.gif?imageMogr2/auto-orient/strip)



##呈现(presentation)与模型(model)
这部分内容比较繁琐，我就只是引用原文的内容了，不过简单来讲就是我们看到的动画(presentation)与我们实际操作的图层(model)时两个图层。
`CALayer`的属性行为其实很不正常，因为改变一个图层的属性并没有立刻生效，而是通过一段时间渐变更新。这是怎么做到的呢？
当你改变一个图层的属性，属性值的确是立刻更新的（如果你读取它的数据，你会发现它的值在你设置它的那一刻就已经生效了），但是屏幕上并没有马上发生改变。这是因为你设置的属性并没有直接调整图层的外观，相反，他只是定义了图层动画结束之后将要变化的外观。
当设置 `CALayer` 的属性，实际上是在定义当前事务结束之后图层如何显示的模型。`Core Animation` 扮演了一个控制器的角色，并且负责根据图层行为和事务设置去不断更新视图的这些属性在屏幕上的状态。
我们讨论的就是一个典型的微型 `MVC` 模式。`CALayer` 是一个连接用户界面（就是 `MVC` 中的 `view` ）虚构的类，但是在界面本身这个场景下，`CALayer` 的行为更像是存储了视图如何显示和动画的数据模型。实际上，在苹果自己的文档中，图层树通常都是值的图层树模型。
在`iOS`中，屏幕每秒钟重绘60次。如果动画时长比60分之一秒要长， `Core Animation` 就需要在设置一次新值和新值生效之间，对屏幕上的图层进行重新组织。这意味着 `CALayer` 除了“真实”值（就是你设置的值）之外，必须要知道当前显示在屏幕上的属性值的记录。
每个图层属性的显示值都被存储在一个叫做呈现图层的独立图层当中，他可以通过 `-presentationLayer` 方法来访问。这个呈现图层实际上是模型图层的复制，但是它的属性值代表了在任何指定时刻当前外观效果。换句话说，你可以通过呈现图层的值来获取当前屏幕上真正显示出来的值。
我们在第一章中提到除了图层树，另外还有呈现树。呈现树通过图层树中所有图层的呈现图层所形成。注意呈现图层仅仅当图层首次被提交（就是首次第一次在屏幕上显示）的时候创建，所以在那之前调用 `-presentationLayer` 将会返回nil。
你可能注意到有一个叫做 `–modelLayer` 的方法。在呈现图层上调用 `–modelLayer` 将会返回它正在呈现所依赖的 `CALayer` 。通常在一个图层上调用 `-modelLayer` 会返回 `self`（实际上我们已经创建的原始图层就是一种数据模型）。


![](http://upload-images.jianshu.io/upload_images/1687521-a0f39cafa532f898.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

大多数情况下，你不需要直接访问呈现图层，你可以通过和模型图层的交互，来让 `Core Animation` 更新显示。两种情况下呈现图层会变得很有用，一个是同步动画，一个是处理用户交互。

* 如果你在实现一个基于定时器的动画，而不仅仅是基于事务的动画，这个时候准确地知道在某一时刻图层显示在什么位置就会对正确摆放图层很有用了。
* 如果你想让你做动画的图层响应用户输入，你可以使用-hitTest:方法来判断指定图层是否被触摸，这时候对呈现图层而不是模型图层调用-hitTest:会显得更有意义，因为呈现图层代表了用户当前看到的图层位置，而不是当前动画结束之后的位置。

接下来的例子中，点击屏幕上的任意位置将会让图层平移到那里。点击图层本身可以随机改变它的颜色。我们通过对呈现图层调用 `-hitTest:` 来判断是否被点击。
如果修改代码让 `-hitTest:` 直接作用于 `colorLayer` 而不是呈现图层，你会发现当图层移动的时候它并不能正确显示。这时候你就需要点击图层将要移动到的位置而不是图层本身来响应点击（这就是为什么用呈现图层来响应交互的原因）。
```swift
class HitTestViewController: UIViewController {
weak var colorLayer: CALayer!
override func viewDidLoad() {
super.viewDidLoad()
let layer = CALayer()
view.layer.addSublayer(layer)
layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
layer.position = view.layer.position
layer.backgroundColor = UIColor.red.cgColor
colorLayer = layer
}

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
let point = touches.first?.location(in: view)
if self.colorLayer.presentation()?.hitTest(point!) != nil {
let red = CGFloat(arc4random() % 256) / 255.0
let green = CGFloat(arc4random() % 256) / 255.0
let blue = CGFloat(arc4random() % 256) / 255.0
colorLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
} else {
CATransaction.begin()
CATransaction.setAnimationDuration(4.0)
colorLayer.position = point!
CATransaction.commit()
}
}
}
```

![](http://upload-images.jianshu.io/upload_images/1687521-931ee021c49aa1eb.gif?imageMogr2/auto-orient/strip)

##总结
本章主要介绍了 `Core Animation` 的隐式动画已经背后实现的原理。

##往期回顾：
[序章](http://www.jianshu.com/p/c4b7b37cf805)
[第一章 - 图层树](http://www.jianshu.com/p/dbf2069cc90b)
[第二章 - 寄宿图](http://www.jianshu.com/p/dae6ccdf3672)
[第三章 - 图层几何](http://www.jianshu.com/p/f12d36b33450)
[第四章 - 视觉效果](http://www.jianshu.com/p/f9130ac64cdd)
[第五章 - 变换](http://www.jianshu.com/p/58bcf00b5901)
[第六章 专用图层（上）](http://www.jianshu.com/p/58bcf00b5901)
[第六章 专用图层（下）](http://www.jianshu.com/p/3cbfd4680525)
[项目中使用的代码](https://github.com/Hoikiiz/CoreAnimationGuideline)





















