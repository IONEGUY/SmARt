//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct FileData: FileDataProtocol, Codable {
    var id: String = .empty
    var url: String = .empty
    var fileExtension = "usdz"
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
    }
}
