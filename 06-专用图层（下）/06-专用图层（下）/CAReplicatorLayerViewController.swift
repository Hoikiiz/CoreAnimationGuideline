//
//  CAReplicatorLayerViewController.swift
//  06-专用图层（下）
//
//  Created by SunYang on 17/2/19.
//  Copyright © 2017年 SunYang. All rights reserved.
//

import UIKit

class CAReplicatorLayerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
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
}
