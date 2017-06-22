//
//  UIImage+JChat.swift
//  JChat
//
//  Created by deng on 2017/6/20.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

extension UIImage {
    
    func fixOrientation() -> UIImage {
        var image = self
        if self.imageOrientation == .up {
            return image
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: .pi / 2)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored :
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width,y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .rightMirrored, .leftMirrored:
            transform = transform.translatedBy(x: image.size.height,y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        let ctx = CGContext(data: nil , width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)
        
        ctx!.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            ctx?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        }
        
        let cgImage = ctx!.makeImage()
        image = UIImage(cgImage: cgImage!)
        return image
    }

}
