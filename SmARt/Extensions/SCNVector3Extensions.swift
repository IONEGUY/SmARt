//
//  SCNVector3Extensions.swift
//  SmARt
//
//  Created by MacBook on 18.03.21.
//

import Foundation
import SceneKit

extension SCNVector3 {
    static func center(of start: SCNVector3, and end: SCNVector3) -> SCNVector3 {
        SCNVector3(x: (start.x + end.x) / 2,
                   y: (start.y + end.y) / 2,
                   z: (start.z + end.z) / 2)
    }
    
    static func distance(between start: SCNVector3, and end: SCNVector3) -> Float {
        let x1 = start.x
        let x2 = end.x

        let y1 = start.y
        let y2 = end.y

        let z1 = start.z
        let z2 = end.z

        return sqrtf((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1) + (z2-z1) * (z2-z1))
    }
    
    static func eulerAngle(between start: SCNVector3, and end: SCNVector3, distance: Float) -> SCNVector3 {
        SCNVector3(Float.pi / 2,
                   acos((start.z - end.z) / distance),
                   atan2((start.y - end.y), (start.x - end.x)))
    }
    
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }
}
