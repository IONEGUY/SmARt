//
//  ExtendedRealityKitViewDelegate.swift
//  SmARt
//
//  Created by MacBook on 22.03.21.
//

import Foundation
import ARKit
import RealityKit

protocol ExtendedRealityKitViewDelegate {
    func doOnTap(_ sender: ExtendedRealityKitView, _ transform: simd_float4x4)
    func entitySelected(_ entity: Entity)
}
