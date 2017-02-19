//
//  CATiledLayerViewController.swift
//  06-专用图层（下）
//
//  Created by SunYang on 17/2/19.
//  Copyright © 2017年 SunYang. All rights reserved.
//

import UIKit

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
