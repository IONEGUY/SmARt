//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct VideoData: Codable {
    var icon: ImageData?
    var name: String?
    var description: String?
    var size: Int64?
    var url: String?
    var type: String?
    var isLive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case icon
        case name
        case description
        case size
        case url
        case type
        case isLive
    }
}
