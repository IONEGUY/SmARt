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
import ARKit

class MenuViewModel: BaseViewModel, ObservableObject {
    private var progresses: [Float] = []
    
    var sections = [Section]()
    var menuItems = [MenuItemData]()
    @Published var pushActive = false
    var onMenuItemSelected = PassthroughSubject<String, Never>()
    var section: Section?
    
    override init() {
        super.init()
        
        let getSectionsPublisher = MenuService(ApiErrorLogger()).getSections()
        
        getSectionsPublisher
            .filter(isAllowedToDownloadMediaContent)
            .map(\.sections)
            .map(constructFilesForMenu)
            .sink(receiveCompletion: {_ in}, receiveValue: performFilesLoading)
            .store(in: &cancellables)
        
        getSectionsPublisher
            .map(\.sections)
            .sink {_ in}
                receiveValue: { [unowned self] in initMenuItems($0) }
            .store(in: &cancellables)
        
        $contentLoadingProgress
            .sink(receiveCompletion: {_ in }, receiveValue: { (progress: Progress) in
                switch progress {
                case .finished: UserDefaults.standard.setValue(true, forKey: "isContentLoaded")
                default: break       
                }})
            .store(in: &cancellables)
        
        onMenuItemSelected
            .sink { [unowned self] menuItemId in
                section = sections.first { $0.id == menuItemId }
                pushActive = true
            }
            .store(in: &cancellables)
    }
    
    private func initMenuItems(_ section: [Section]) {
        self.sections = section
        menuItems = sections.compactMap {
            if $0.typeSection == SectionType.smartRetail.rawValue && !ARFaceTrackingConfiguration.isSupported {
                return nil
            }
            
            return MenuItemData(id: $0.id,
                                logo3DId: $0.logo3d.id,
                                sectionName: $0.menuName,
                                sectionDescription: $0.menuDescription) }
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
    
    override func performFilesLoading(files: [FileProtocol]) {
        removeOutdatedMediaFiles()
        super.performFilesLoading(files: files)
    }
    
    private func removeOutdatedMediaFiles() {
        let fileManager = FileManager()
        constructAllMediaFiles(sections).forEach {
            let fileUrl = URL.constructFilePath(in: .documentDirectory, withName: $0.nameWithExtension)
            try? fileManager.removeItem(at: fileUrl)
        }
    }
    
    private func constructAllMediaFiles(_ sections: [Section]) -> [FileProtocol] {
        let objects3D = sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.object3d)
        
        let menuFiles = constructFilesForMenu(sections)
        
        //models
        let object3DFiles = objects3D.compactMap(\.files).flatMap { $0 }
        
        //videos
        let videos: [FileProtocol] = sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.video)
        
        return [videos, object3DFiles, menuFiles].flatMap { $0 }
    }
    
    private func constructFilesForMenu(_ sections: [Section]) -> [FileProtocol] {
        let objects3D = sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.object3d)
        
        //images
        let object3DImages = objects3D.compactMap(\.icon)
        let complexDescriptionImages: [FileProtocol] =
            sections.compactMap(\.complexDescription?.items).flatMap { $0 }.map(\.icon)
        let logo3dImages: [FileProtocol] = sections.map(\.logo2d)
        let videoImages: [FileProtocol] =
            sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.video).compactMap { $0.icon }
        let masks: [FileProtocol] =
            sections.compactMap(\.objects).flatMap { $0 }.compactMap(\.mask).compactMap { $0.icon }
        
        //models
        let logo3dFiles: [FileProtocol] = sections.map(\.logo3d)
        
        return [logo3dFiles, object3DImages, videoImages, logo3dImages, masks,
                complexDescriptionImages].flatMap { $0 }
    }
}
