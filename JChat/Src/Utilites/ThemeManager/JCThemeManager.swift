//
//  JCThemeManager.swift
//  JChat
//
//  Created by deng on 2017/2/16.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit

class JCThemeManager: NSObject {

}


extension UIImage {
    static let themeBundlePath = Bundle.path(forResource: "defaultTheme", ofType: "bundle", inDirectory: Bundle.main.bundlePath)
    static func loadImage(_ imageName: String) -> UIImage {
        let themeBundle = Bundle.init(path: themeBundlePath!)!
        var image = UIImage()
        var isImageUnder3x = false
        if imageName.characters.count > 0 {
            var nameAndType = imageName.components(separatedBy: ".")
            var name: String!
            name = nameAndType.first
            let type = nameAndType.count > 1 ? nameAndType[1] : "png"
            var imagePath: String!
            imagePath  =  themeBundle.path(forResource: "image/" + name, ofType: type)
            let nameLength = name.characters.count
            if imagePath == nil && (name?.hasSuffix("@2x"))! && nameLength > 3 {
                let index = name.index(name.endIndex, offsetBy: -3)
                name = name.substring(with: Range<String.Index>(name.startIndex ..< index))
            }
            if imagePath == nil && !name.hasSuffix("@2x") {
                let name2x = name + "@2x";
                imagePath = themeBundle.path(forResource: "image/" + name2x, ofType: type)
                if imagePath == nil && !name.hasSuffix("3x") {
                    let name3x = name + "@3x"
                    imagePath = themeBundle.path(forResource: "image/" + name3x, ofType: type)
                    isImageUnder3x = true
                }
            }
            if imagePath != nil {
                image = UIImage(contentsOfFile: imagePath)!
            }
        }
        if #available(iOS 8, *) {
            return image.withRenderingMode(.alwaysOriginal)
        }
        if !isImageUnder3x {
            return image.withRenderingMode(.alwaysOriginal)
        }
        return image.scaledImageFrom3x()
    }
    
    static func createImage(color: UIColor, size: CGSize) -> UIImage? {
        
        var rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    private func scaledImageFrom3x() -> UIImage {
        let locScale = UIScreen.main.scale
        let theRate: CGFloat = 1.0 / 3.0
        let oldSize = self.size
        let scaleWidth = CGFloat(oldSize.width) * theRate
        let scaleHeight = CGFloat(oldSize.height) * theRate
        var scaleRect = CGRect.zero
        scaleRect.size.width = scaleWidth
        scaleRect.size.height = scaleHeight
        UIGraphicsBeginImageContextWithOptions(scaleRect.size, false, locScale)
        draw(in: scaleRect)
        var newImage = UIImage()
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage.withRenderingMode(.alwaysOriginal)
    }
}
