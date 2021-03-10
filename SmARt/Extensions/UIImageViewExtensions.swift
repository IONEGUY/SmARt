//
//  UIImageViewExtensions.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import Foundation
import UIKit

extension UIImage {
    static func read(from directory: FileManager.SearchPathDirectory, name: String) -> UIImage {
        let url = URL.constructFilePath(withName: "\(name).png").path
        return UIImage(contentsOfFile: url) ?? UIImage()
    }
}
