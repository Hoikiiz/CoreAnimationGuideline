//
//  TransactionViewController.swift
//  07-隐式动画
//
//  Created by SunYang on 17/2/24.
//  Copyright © 2017年 SunYang. All rights reserved.
//

import UIKit

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
