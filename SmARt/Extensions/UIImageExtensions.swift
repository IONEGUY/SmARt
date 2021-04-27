//
//  UIImageViewExtensions.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import Foundation
import UIKit

extension UIImage {
    static func read(from directory: FileManager.SearchPathDirectory = .documentDirectory, name: String) -> UIImage {
        let url = URL.constructFilePath(in: directory, withName: "\(name).png").path
        let image = UIImage(contentsOfFile: url) ?? UIImage()
        image.accessibilityIdentifier = name
        return image
    }
}
