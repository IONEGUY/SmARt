//
//  TakeSnapshotButton.swift
//  SmARt
//
//  Created by MacBook on 15.04.21.
//

import Foundation
import UIKit

class TakeSnapshotButton: UIButton {
    var targetView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        setImage(UIImage(named: "camera"), for: .normal)
        tintColor = .white
        layer.cornerRadius = 8
        backgroundColor = UIColor(hex: "#C4C4C4", alpha: 0.7)
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(takeSnapshot), for: .touchUpInside)
    }
    
    @objc func takeSnapshot() {
        guard let image = targetView?.toImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
