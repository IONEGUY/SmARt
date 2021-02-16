//
//  SectionsViewModel.swift
//  SmARt
//
//  Created by MacBook on 2/8/21.
//

import Foundation
import Combine
import Alamofire

class MenuViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    
    var sectionsList3DItemData = [SectionsList3DItemData]()
    var sections = [Section]()
    var sectionItemSelected: (String) -> Void = { _ in }
    
    init() {
        MenuService(ApiErrorLogger()).getSections()
            .map(\.sections)
            .replaceError(with: [])
            .filter { !$0.isEmpty }
            .receive(on: RunLoop.main)
            .sink { [unowned self] in createMenuData($0) }
            .store(in: &cancellableSet)
        
        sectionItemSelected = sectionSelected
    }
    
//    private func convertSectionDtoToSectionsList3DItemData(dtos: [Section]) -> [SectionsList3DItemData] {
//        return dtos
//            .map { SectionsList3DItemData(id: $0.id,
//                                          object3DUrl: $0.logo3d.url,
//                                          object3DName: $0.logo3d.fileName ?? .empty,
//                                          sectionName: $0.menuName,
//                                          sectionDescription: $0.menuDescription) }
//            .reversed()
//    }
    
    private func createMenuData(_ sections: [Section]) {
        self.sections = sections
        let dispatchGroup = DispatchGroup()
        var sectionsList3DItemData = [SectionsList3DItemData]()
        sections.forEach { section in
            dispatchGroup.enter()
            AF.download(section.logo3d.url, method: .get).responseData { response in
                guard let fileName = section.logo3d.fileName,
                      let filePath = FileManager.default.urls(
                    for: .cachesDirectory,
                    in: .userDomainMask).first?.appendingPathComponent("\(fileName).usdz"),
                    (try? response.result.get().write(to: filePath)) != nil else { return }

                    sectionsList3DItemData.append(
                        SectionsList3DItemData(id: section.id,
                                               object3DFileUrl: filePath,
                                               object3DName: fileName,
                                               sectionName: section.menuName,
                                               sectionDescription: section.menuDescription))

                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.sectionsList3DItemData = [sectionsList3DItemData.first!, sectionsList3DItemData.first!, sectionsList3DItemData.first!, sectionsList3DItemData.first!, sectionsList3DItemData.first!]
        }
    }
    
    private func sectionSelected(_ menuItemId: String) {
        print(menuItemId)
        let section = sections.first { $0.id == menuItemId }
        
    }
}
