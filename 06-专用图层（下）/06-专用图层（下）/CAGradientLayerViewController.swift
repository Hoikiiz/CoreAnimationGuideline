//
//  CAGradientLayerViewController.swift
//  06-专用图层（下）
//
//  Created by SunYang on 17/2/15.
//  Copyright © 2017年 SunYang. All rights reserved.
//

import UIKit

class CAGradientLayerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.containerView.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
        gradientLayer.locations = [0.0, 0.25, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.containerView.layer.addSublayer(gradientLayer)
    }
}
