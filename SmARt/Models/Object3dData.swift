//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct Object3dData: Codable {
    var icon: ImageData?
    var name: String?
    var description: String?
    var files: [FileData]?
    var isStatic: Bool?
    
    enum CodingKeys: String, CodingKey {
        case icon
        case name
        case description
        case files
        case isStatic
    }
}
