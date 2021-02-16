//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct FileData: Codable {
    var name: String?
    var description: String?
    var size: Int64?
    var url: String
    var fileName: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case size
        case url
        case fileName
    }
}
