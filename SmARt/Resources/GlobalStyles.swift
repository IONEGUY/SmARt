//
//  GlobalStyles.swift
//  SmARt
//
//  Created by MacBook on 11/21/20.
//

import Foundation
import UIKit

class GlobalStyles {
    class func initialize() {
        setupTransparentNavigationBar()
    }

    private class func setupTransparentNavigationBar() {
        UINavigationBar.appearance().isHidden = true
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
}
