//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct VideoData: FileProtocol, Codable {
    var id: String
    var icon: ImageData
    var name: String
    var description: String
    var url: String
    var fileExtension = "mp4"
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case name
        case description
        case url
    }
}
