//
//  OnboardingViewModel.swift
//  SmARt
//
//  Created by MacBook on 19.03.21.
//

import Foundation
import Combine
import SwiftUI

class OnboardingViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    var pushMenuPage = PassthroughSubject<Void, Never>()
    
    @Published var pageIndex: Int = 0
    @Published var getStartedButtonText: String = .empty
    @Published var sectionsConfig = [
        (image: "control_your_equipment", title: "Learn and control your equipment"),
        (image: "explor_more_interesting", title: "Explore more interesting"),
        (image: "find_usefull", title: "Find usefull")
    ]
    
    init() {
        $pageIndex
            .map { [unowned self] in $0 == sectionsConfig.count - 1 ? "Get Started" : "Next" }
            .assign(to: \.getStartedButtonText, on: self)
            .store(in: &cancellableSet)
    }
    
    func getStartedButtonAction() {
        if pageIndex == sectionsConfig.count - 1 {
            pushMenuPage.send()
        } else {
            pageIndex += 1
        }
    }
}
