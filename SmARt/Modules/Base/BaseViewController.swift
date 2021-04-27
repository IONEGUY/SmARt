//
//  BaseViewController.swift
//  SmARt
//
//  Created by MacBook on 23.03.21.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class BaseViewController: UIViewController {
    private let navBarHorizontalMargin: CGFloat = 20
    
    var cancellables = Set<AnyCancellable>()
    @Published var loadingProgress = Progress.none
    
    var loadingView = LoadingViewWithProgressBar()
    var proposalForInteractionMessage = InteractionMessage()
    var loadingViewContainer = UIView()
    
    var isNavigationBarVisible: Bool { true }
    
    var navBar: NavBar = {
        let navBar = NavBar()
        navBar.backgroundColor = .clear
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavBar()
        
        $loadingProgress
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {_ in}, receiveValue: { [unowned self] in
                switch $0 {
                case .started: addLoadingView()
                case .value(let progress): loadingView.updateProgress(CGFloat(progress))
                case .finished: loadingViewContainer.removeFromSuperview()
                default: break
                }})
            .store(in: &cancellables)
    }
    
    func addProposalForInteractionMessage(withTitle title: String) {
        proposalForInteractionMessage.message = title
        view.addSubview(proposalForInteractionMessage)
        proposalForInteractionMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            proposalForInteractionMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            proposalForInteractionMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func removeProposalForInteractionMessage() {
        proposalForInteractionMessage.removeFromSuperview()
    }
    
    func addLoadingView() {
        loadingView.text = "Fetching Media Content"
        loadingViewContainer = UIView()
        loadingViewContainer.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.addSubview(loadingViewContainer)
        loadingViewContainer.fillSuperview()
        loadingViewContainer.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func addTakeSnapshotButton(of targetView: UIView) {
        let takeSnapshotButton = TakeSnapshotButton()
        takeSnapshotButton.translatesAutoresizingMaskIntoConstraints = false
        navBar.appendViewToRightSide(takeSnapshotButton)
        takeSnapshotButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        takeSnapshotButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        takeSnapshotButton.targetView = targetView
    }
    
    func createNavBar(title: String = .empty) {
        if !isNavigationBarVisible { return }
        navBar.title = title
        view.addSubview(navBar)
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: navBarHorizontalMargin),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -navBarHorizontalMargin),
        ])
    }
}
