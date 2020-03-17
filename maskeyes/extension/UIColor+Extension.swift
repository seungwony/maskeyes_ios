//
//  UIColor+RGB.swift
//  lutcamera
//
//  Created by SEUNGWON YANG on 2019/12/26.
//  Copyright © 2019 co.giftree. All rights reserved.
//

import Foundation
import UIKit

struct ColorPalette {
    
    static let white = UIColor(red: 255, green: 255, blue: 255)
    static let black = UIColor(red: 3, green: 3, blue: 3)
   
    static let stat_plenty = UIColor(rgb: 0x47A34B)
    static let stat_some = UIColor(rgb: 0xFF8707)
    static let stat_few = UIColor(rgb: 0xF44336)
    static let stat_empty = UIColor(rgb: 0x929292)
    static let stat_unknown = UIColor(rgb: 0x424242)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
