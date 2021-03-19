//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct ImageData: FileProtocol, Codable {
    var id: String = .empty
    var url: String = .empty
    var fileExtension = "png"
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
    }
}
