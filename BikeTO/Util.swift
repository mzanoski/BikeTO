//
//  Util.swift
//  BikeTO
//
//  Created by Marko Zanoski on 2016-02-17.
//  Copyright © 2016 Marko Zanoski. All rights reserved.
//

import Foundation
import UIKit

class Utilities {

    static func imageFromColor(color: UIColor, forSize size: CGSize) -> UIImage? {
//    (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect);
        
        var image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContext(size);
        
        // Add a clip before drawing anything, in the shape of an rounded rect
        UIBezierPath(roundedRect: rect, cornerRadius: 0).addClip()
        
        // Draw your image
        image.drawInRect(rect)
        
        // Get the image, here setting the UIImageView image
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
        
        return image;
        
    }
}