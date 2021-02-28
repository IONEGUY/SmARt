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
    private var sections = [Section]()
    
    @Published var menuItems = [MenuItemData]()
    @Published var pushActive = false
    @Published var onMenuItemSelected = PassthroughSubject<String, Never>()
    @Published var section: Section?
    
    init() {
        MenuService(ApiErrorLogger()).getSections()
            .map(\.sections)
            .replaceError(with: [])
            .filter { !$0.isEmpty }
            .receive(on: RunLoop.main)
            .sink { [unowned self] in createMenuData($0) }
            .store(in: &cancellableSet)
        
        onMenuItemSelected
            .sink { [unowned self] menuItemId in
                section = sections.first { $0.id == menuItemId }
                pushActive = true
            }
            .store(in: &cancellableSet)
    }
    
    private func createMenuData(_ sections: [Section]) {
        self.sections = sections
        let dispatchGroup = DispatchGroup()
        var menuItems = [MenuItemData]()
        
        sections.forEach { section in
            dispatchGroup.enter()
            AF.download(section.logo3d.url, method: .get).responseData { response in
                guard let fileName = section.logo3d.fileName,
                      let filePath = FileManager.default.urls(
                    for: .cachesDirectory,
                    in: .userDomainMask).first?.appendingPathComponent("\(fileName).usdz"),
                    (try? response.result.get().write(to: filePath)) != nil else { return }

                menuItems.append(MenuItemData(id: section.id,
                                              object3DFileUrl: filePath,
                                              object3DName: fileName,
                                              sectionName: section.menuName,
                                              sectionDescription: section.menuDescription))
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.menuItems = menuItems
        }
    }
}
