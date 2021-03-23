//
//  UIImageExtensions.swift
//  SmARt
//
//  Created by MacBook on 10.03.21.
//

import Foundation

extension URL {
    static func constructFilePath(in directory: FileManager.SearchPathDirectory = .documentDirectory, withName name: String) -> URL {
        guard let filePath = FileManager.default
                .urls(for: .documentDirectory, in: .allDomainsMask).first?
                .appendingPathComponent(name)
        else { fatalError("Cannot construct url") }
        return filePath
    }
}
