//
//  File.swift
//  SmARt
//
//  Created by MacBook on 2/5/21.
//

import Foundation

struct ComplexDescriptionItem: Codable, Identifiable {
    var id = UUID()
    var icon: ImageData
    var title: String
    var subtitle: String?
    
    enum CodingKeys: String, CodingKey {
        case icon
        case title
        case subtitle
    }
}
