//
//  UIColorExtensions.swift
//  SmARt
//
//  Created by MacBook on 15.04.21.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: UInt) {
        let red = CGFloat((hex >> 16) & 0xff) / 255
        let green = CGFloat((hex >> 08) & 0xff) / 255
        let blue = CGFloat((hex >> 00) & 0xff) / 255

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    convenience init(hexWithAlpha: UInt) {
        let red = CGFloat((hexWithAlpha & 0xff000000) >> 24) / 255
        let green = CGFloat((hexWithAlpha & 0x00ff0000) >> 16) / 255
        let blue = CGFloat((hexWithAlpha & 0x0000ff00) >> 8) / 255
        let alpha = CGFloat(hexWithAlpha & 0x000000ff) / 255

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
