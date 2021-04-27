//
//  ARScannerViewModel.swift
//  SmARt
//
//  Created by MacBook on 22.04.21.
//

import Foundation

class ARScannerViewModel: GeneralARViewModel {
    var triggers: [String : String]
    
    init(triggers: [String : String]) {
        self.triggers = triggers
        super.init()
        var files: [FileProtocol] = []
        files.append(contentsOf: constructFiles(triggers.keys.map { $0 }, .image))
        files.append(contentsOf: constructFiles(triggers.values.map { $0 }, .object3D))
        performFilesLoading(files: files)
    }
    
    @discardableResult
    override func performFilesLoading(files: [FileProtocol]) -> [FileProtocol] {
        let downloadableFiles = super.performFilesLoading(files: files)
        if downloadableFiles.isEmpty { contentLoadingProgress = .finished }
        return downloadableFiles
    }
}
