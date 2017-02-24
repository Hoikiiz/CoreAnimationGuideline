//
//  HitTestViewController.swift
//  07-隐式动画
//
//  Created by SunYang on 17/2/24.
//  Copyright © 2017年 SunYang. All rights reserved.
//

import UIKit

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
