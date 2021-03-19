//
//  OutlinedLabel.swift
//  SmARt
//
//  Created by MacBook on 18.03.21.
//

import Foundation
import UIKit

@IBDesignable class OutlinedLabel: UILabel {
    override func awakeFromNib() {
        let strokeTextAttributes = [
          NSAttributedString.Key.strokeColor : UIColor.white,
          NSAttributedString.Key.foregroundColor : UIColor.white,
          NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: self.font.pointSize)]
          as [NSAttributedString.Key : Any]

        attributedText = NSMutableAttributedString(string: text ?? .empty,
                                                   attributes: strokeTextAttributes)
    }
}
