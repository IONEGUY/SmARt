//
//  ARViewExtensions.swift
//  SmARt
//
//  Created by MacBook on 15.04.21.
//

import Foundation
import ARKit
import SceneKit
import RealityKit
import Combine

extension ARView {
    func takeARSessionSnapshot(saveToAlbum: Bool = true) -> AnyPublisher<UIImage, Error> {
        AnyPublisher.create { [unowned self] observer in
            snapshot(saveToHDR: false) { image in
                guard let image = image else {
                    observer.onError(NSError())
                    print("Failed to take snapshot of the AR session!")
                    return
                }
                
                if saveToAlbum {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                
                observer.onNext(image)
                observer.onComplete()
            }
            return .init(dispose: {})
        }
    }
}

extension ARSCNView {
    @discardableResult
    func takeARSessionSnapshot(saveToAlbum: Bool = true) -> UIImage {
        let image = snapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        return image
    }
}
