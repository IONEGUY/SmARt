//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct ComplexDescription: Codable {
    var items: [ComplexDescriptionItem]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}
