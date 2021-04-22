//
//  BaseViewModel.swift
//  SmARt
//
//  Created by MacBook on 16.04.21.
//

import Foundation
import Combine

class BaseViewModel {
    var cancellables = Set<AnyCancellable>()
    @Published var contentLoadingProgress: Progress = .none
    var fileLoader = FileLoader()
    
    func performFilesLoading(files: [FileProtocol]) {
        let nonCachedfiles = files.filter { !URL.isFileExist(withName: $0.nameWithExtension) }
        
        fileLoader.progress
            .assign(to: \.contentLoadingProgress, on: self)
            .store(in: &cancellables)
        
        fileLoader.download(files: nonCachedfiles)
    }
}
