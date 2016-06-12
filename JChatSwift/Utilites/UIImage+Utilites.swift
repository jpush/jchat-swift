//
//  UIImage+Utilites.swift
//  JChatSwift
//
//  Created by oshumini on 16/6/12.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

typealias Filter = CIImage -> UIImage?

extension UIImage {
  
  class func blur(radius:Double, inputImage:UIImage) -> UIImage? {

    let filter = CIFilter(name: "CIGaussianBlur")
    let beginImage = CoreImage.CIImage(image: inputImage)
    filter?.setValue(beginImage, forKey: kCIInputImageKey)
    filter?.setValue(radius, forKey: kCIInputRadiusKey)
    
    let cimage = (filter?.outputImage)!
    return UIImage(CIImage: cimage)
  }

}