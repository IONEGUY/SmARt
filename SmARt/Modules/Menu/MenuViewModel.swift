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
    @Published var sections = [Section]()
    private var progresses: [Float] = []
    
    @Published var menuItems = [MenuItemData]()
    @Published var pushActive = false
    @Published var onMenuItemSelected = PassthroughSubject<String, Never>()
    @Published var section: Section?
    @Published var isLoading = false
    @Published var averageProgress: Float = 0
    
    init() {
        MenuService(ApiErrorLogger()).getSections()
            .flatMap(cache3DModels)
            .sink(receiveCompletion: {_ in},
                  receiveValue: { [unowned self] _ in isLoading = false} )
            .store(in: &cancellableSet)
        
        $sections
            .removeDuplicates(by: { $0.count == $1.count })
            .filter { !$0.isEmpty }
            .flatMap(initMenuItems)
            .assign(to: \.menuItems, on: self)
            .store(in: &cancellableSet)
        
        onMenuItemSelected
            .sink { [unowned self] menuItemId in
                section = sections.first { $0.id == menuItemId }
                pushActive = true
            }
            .store(in: &cancellableSet)
    }
    
    private func initMenuItems(_ sections: [Section]) -> AnyPublisher<[MenuItemData], Never> {
        AnyPublisher.create { [unowned self] observer in
            menuItems = sections.map { MenuItemData(
                id: $0.id, object3DFileUrl: $0.logo3d.url,
                sectionName: $0.menuName, sectionDescription: $0.menuDescription) }
            observer.onComplete()
            return Disposable(dispose: {})
        }
    }
    
    private func cache3DModels(_ environment: EnvironmentOut) -> AnyPublisher<Void, Never> {
        AnyPublisher.create { [unowned self] observer in
            sections = environment.sections
            
            if environment.version <= (UserDefaults.standard.value(forKey: "version") as? Int ?? -1) {
                observer.onNext(Void())
                return Disposable(dispose: {})
            }
            
            UserDefaults.standard.set(environment.version, forKey: "version")

            isLoading = true
            let dispatchGroup = DispatchGroup()
            let urls = [sections.map(\.logo3d.url), sections.compactMap(\.objects).flatMap { $0 }
                .compactMap(\.object3d?.files).flatMap { $0 }.map(\.url)].flatMap { $0 }
            progresses = [Float](repeating: Float(), count: urls.count)
            urls.enumerated().forEach { (index, url) in
                dispatchGroup.enter()
                AF.download(url)
                    .downloadProgress {
                        progresses[index] = Float($0.fractionCompleted)
                        updateLoadingProgress()
                    }
                    .responseData { response in
                        if let object3DName = url.split(separator: "/").last,
                           let filePath = FileManager.default
                            .urls(for: .cachesDirectory, in: .userDomainMask)
                            .first?.appendingPathComponent("\(object3DName).usdz") {
                            try? response.result.get().write(to: filePath)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: DispatchQueue.global()) { observer.onNext(Void()) }
            
            return Disposable(dispose: {})
        }
    }
    
    private func updateLoadingProgress() {
        DispatchQueue.main.async { [unowned self] in
            averageProgress = progresses.reduce(0.0, +) / Float(progresses.count)
        }
    }
}
