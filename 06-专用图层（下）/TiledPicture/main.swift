//
//  main.swift
//  TiledPicture
//
//  Created by SunYang on 17/2/19.
//  Copyright © 2017年 SunYang. All rights reserved.
//

import Foundation
import AppKit

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







