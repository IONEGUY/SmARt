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
        setBackgroundImage(UIImage(systemName: "camera.fill"), for: .normal)
        contentMode = .scaleToFill
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(takeARSessionSnapshot), for: .touchUpInside)
    }
    
    @objc func takeARSessionSnapshot() {
        guard let image = targetView?.toImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
