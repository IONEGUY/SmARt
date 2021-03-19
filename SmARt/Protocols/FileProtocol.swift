//
//  FileDataProtocol.swift
//  SmARt
//
//  Created by MacBook on 9.03.21.
//

import Foundation

protocol FileProtocol {
    var id: String { get set }
    var url: String { get set }
    var fileExtension: String { get set }
}

extension FileProtocol {
    var nameWithExtension: String { "\(id).\(fileExtension)" }
}
