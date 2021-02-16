//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct Section: Codable {
    var id: String
    var name: String?
    var description: String?
    var complexDescription: ComplexDescription?
    var logo2d: ImageData?
    var logo3d: FileData
    var typeSection: String?
    var sections: [Section]?
    var objects: [ObjectData]?
    var menuName: String
    var menuDescription: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case complexDescription
        case logo2d
        case logo3d
        case typeSection
        case sections
        case objects
        case menuName
        case menuDescription
    }
}
