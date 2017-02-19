//
//  CAEmitterLayerViewController.swift
//  06-专用图层（下）
//
//  Created by SunYang on 17/2/19.
//  Copyright © 2017年 SunYang. All rights reserved.
//

import UIKit

class CAEmitterLayerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!

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
}
