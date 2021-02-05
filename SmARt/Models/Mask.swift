//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct Mask: Codable {
    var icon: ImageData?
    var description: String?
    var size: Int64?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case icon
        case description
        case size
        case url
    }
}
