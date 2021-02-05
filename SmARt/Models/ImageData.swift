//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct ImageData: Codable {
    var name: String?
    var description: String?
    var size: Int64?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case size
        case url
    }
}
