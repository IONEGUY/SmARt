//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct Mask: Codable, Identifiable {
    var id: String
    var icon: ImageData
    var description: String?
    var size: Int64?
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case description
        case size
    }
}
