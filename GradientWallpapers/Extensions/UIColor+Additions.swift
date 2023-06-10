//
//  UIColor+Additions.swift
//  GradientWallpapers
//
//  Created by Walkator on 10/6/23.
//

import UIKit

extension UIColor {
    
    public func colorWithBrightness(_ brightness: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        
        if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
            B += (brightness - 1.0)
            B = max(min(B, 5.0), 0.0)
            
            return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
        }
        
        return self
    }
}
