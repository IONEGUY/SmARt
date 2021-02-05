//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct ObjectData: Codable {
    var icon: ImageData?
    var name: String?
    var description: String?
    var type: String?
    var object3d: Object3dData?
    var video: VideoData?
    var mask: Mask?
    
    enum CodingKeys: String, CodingKey {
        case icon
        case name
        case description
        case type
        case object3d
        case video
        case mask
    }
}
