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

class MenuViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    private var progresses: [Float] = []
    
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
            .flatMap(performLoading)
            .sink {_ in } receiveValue: {}
            .store(in: &cancellableSet)
        
        MenuService(ApiErrorLogger()).getSections()
            .flatMap(initMenuItems)
            .sink {_ in } receiveValue: {_ in}
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
    
    private func performLoading(_ files: [FileDataProtocol]) -> AnyPublisher<Void, Never> {
        AnyPublisher.create { [unowned self] observer in
            progresses = [Float](repeating: Float(), count: files.count)
            let dispatchGroup = DispatchGroup()
            files.enumerated().forEach { (index, file) in
                dispatchGroup.enter()
                let destination: DownloadRequest.Destination = { _, _ in
                    let path = URL.constructFilePath(withName: "\(file.id).\(file.fileExtension)")
                    return (path, [.removePreviousFile])
                }
                AF.download(file.url, to: destination)
                    .downloadProgress(queue: .main) { [unowned self] in
                        updateLoadingState($0, at: index) }
                    .response { _ in dispatchGroup.leave() }
            }
            dispatchGroup.notify(queue: DispatchQueue.main) {
                UserDefaults.standard.set(true, forKey: "isContentLoaded")
                observer.onNext(Void())
            }
            
            return Disposable(dispose: {})
        }
    }
    
    private func constructFilesForCaching(_ environment: EnvironmentOut) -> [FileDataProtocol] {
        let sections = environment.sections
        let objects3D = sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.object3d)
        
        let object3DImages = objects3D.compactMap(\.icon)
        let complexDescriptionImages: [FileDataProtocol] =
            sections.compactMap(\.complexDescription?.items).flatMap { $0 }.map(\.icon)
        let logo3dImages: [FileDataProtocol] = sections.compactMap(\.logo2d)
        
        let logo3dFiles: [FileDataProtocol] = sections.map(\.logo3d)
        let object3DFiles = objects3D.compactMap(\.files).flatMap { $0 }
        
        let videoImages: [FileDataProtocol] =
            sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.video).compactMap { $0.icon }
        
        let videos: [FileDataProtocol] =
            sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.video)
        
        let masks: [FileDataProtocol] =
            sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.mask).compactMap { $0.icon }
        
        return [videos, object3DFiles, logo3dFiles, object3DImages, videoImages, logo3dImages, masks,
                complexDescriptionImages].flatMap { $0 }
    }
    
    private func updateLoadingState(_ progress: Progress, at index: Int) {
        contentLoadingProgress = progresses.reduce(0.0, +) / Float(progresses.count)
        progresses[index] = Float(progress.fractionCompleted)
        print(contentLoadingProgress)
    }
}
