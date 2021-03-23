//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct EnvironmentOut: Codable {
    var id: String
    var name: String?
    var description: String?
    var sections: [Section]
    var version: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case sections
        case version
    }
}
