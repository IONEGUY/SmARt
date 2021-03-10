//
//  DroneARViewModel.swift
//  SmARt
//
//  Created by MacBook on 24.02.21.
//

import Foundation
import Combine
import ARKit
import RealityKit
import MapKit
import CoreLocation

class DroneARViewModel: ObservableObject {
    private var cancellabes = Set<AnyCancellable>()
    private let translationSpeed: Float = 0.03
    private let rotationSpeed: Float = 1
    
    @Published var droneModelId = String.empty
    @Published var objectType = AugmentedObjectType.object3D
    
    @Published var leftJoystickAction: (JoystickDirection) -> Void = {_ in}
    @Published var rightJoystickAction: (JoystickDirection) -> Void = {_ in}
    
    @Published var objectTransform = Transform()
    
    init(droneModelId: String) {
        self.droneModelId = droneModelId
        
        leftJoystickAction = { [unowned self] in
            var transform = objectTransform
            switch $0 {
            case .up: transform.translation.z -= translationSpeed
            case .down: transform.translation.z += translationSpeed
            case .left: transform.translation.x -= translationSpeed
            case .right: transform.translation.x += translationSpeed
            }
            
            objectTransform = transform
        }
        
        rightJoystickAction = { [unowned self] in
            var transform = objectTransform
            var rotationAngle = transform.rotation.angle
            switch $0 {
            case .up: transform.translation.y += translationSpeed
            case .down: transform.translation.y -= translationSpeed
            case .left: rotationAngle += rotationSpeed.toRadians()
            case .right: rotationAngle -= rotationSpeed.toRadians()
            }
            transform.rotation = simd_quatf(angle: rotationAngle, axis: [0,1,0])
            objectTransform = transform
        }
    }
}
