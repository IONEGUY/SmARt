//
//  SectionsViewModel.swift
//  SmARt
//
//  Created by MacBook on 2/8/21.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
import BackgroundTasks

class MenuViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    private var progresses: [Float] = []
    private var fileLoader = FileLoader()
    
    @Published var sections = [Section]()
    @Published var menuItems = [MenuItemData]()
    @Published var pushActive = false
    @Published var onMenuItemSelected = PassthroughSubject<String, Never>()
    @Published var section: Section?
    @Published var contentLoadingProgress: Float = 0
    
    init() {
        MenuService(ApiErrorLogger()).getSections()
            .filter(isAllowedToDownloadMediaContent)
            .map(constructFilesForCaching)
            .sink(receiveCompletion: {_ in}, receiveValue: performLoading)
            .store(in: &cancellableSet)
        
        MenuService(ApiErrorLogger()).getSections()
            .flatMap(initMenuItems)
            .sink {_ in} receiveValue: {_ in}
            .store(in: &cancellableSet)
        
        MenuService(ApiErrorLogger()).getSections()
            .map(\.sections)
            .sink(receiveCompletion: {_ in},
                  receiveValue: { [unowned self] in sections = $0 })
            .store(in: &cancellableSet)
        
        onMenuItemSelected
            .sink { [unowned self] menuItemId in
                section = sections.first { $0.id == menuItemId }
                pushActive = true
            }
            .store(in: &cancellableSet)
    }
    
    private func initMenuItems(_ environment: EnvironmentOut) -> AnyPublisher<[MenuItemData], Never> {
        AnyPublisher.create { [unowned self] observer in
            menuItems = environment.sections.map { MenuItemData(
                id: $0.id, logo3DId: $0.logo3d.id, sectionName: $0.menuName,
                sectionDescription: $0.menuDescription) }
            observer.onComplete()
            return Disposable(dispose: {})
        }
    }

    private func isAllowedToDownloadMediaContent(_ environment: EnvironmentOut) -> Bool {
        let version = environment.version
        let userDefaults = UserDefaults.standard
        
        let isVersionGreaterThatCurrent: Bool =
            version > (userDefaults.value(forKey: "version") as? Int ?? -1)
        
        let isContentLoaded = userDefaults.value(forKey: "isContentLoaded") as? Bool ?? false
        
        userDefaults.set(version, forKey: "version")
        return isVersionGreaterThatCurrent || !isContentLoaded
    }
    
    private func performLoading(_ files: [FileProtocol]) {
        fileLoader.progress
            .assign(to: \.contentLoadingProgress, on: self)
            .store(in: &cancellableSet)
        
        fileLoader.progress
            .sink(receiveCompletion: { _ in UserDefaults.standard.set(true, forKey: "isContentLoaded") },
                  receiveValue: { [unowned self] in contentLoadingProgress = $0 })
            .store(in: &cancellableSet)
        
        fileLoader.download(files: files)
    }
    
    private func constructFilesForCaching(_ environment: EnvironmentOut) -> [FileProtocol] {
        let sections = environment.sections
        let objects3D = sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.object3d)
        
        let object3DImages = objects3D.compactMap(\.icon)
        let complexDescriptionImages: [FileProtocol] =
            sections.compactMap(\.complexDescription?.items).flatMap { $0 }.map(\.icon)
        let logo3dImages: [FileProtocol] = sections.map(\.logo2d)
        
        let logo3dFiles: [FileProtocol] = sections.map(\.logo3d)
        let object3DFiles = objects3D.compactMap(\.files).flatMap { $0 }
        
        let videoImages: [FileProtocol] =
            sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.video).compactMap { $0.icon }
        
        let videos: [FileProtocol] =
            sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.video)
        
        let masks: [FileProtocol] =
            sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.mask).compactMap { $0.icon }
        
        return [videos, object3DFiles, logo3dFiles, object3DImages, videoImages, logo3dImages, masks,
                complexDescriptionImages].flatMap { $0 }
    }
}
