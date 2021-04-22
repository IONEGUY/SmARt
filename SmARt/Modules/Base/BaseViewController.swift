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
    var cancellables = Set<AnyCancellable>()
    @Published var loadingProgress = Progress.none
    
    var loadingView = LoadingViewWithProgressBar()
    var proposalForInteractionMessage = InteractionMessage()
    var loadingViewContainer = UIView()
    
    var isNavigationBarVisible: Bool {
        return true
    }
    
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
    
    func addTakeARSessionSnapshotButton(targetView: UIView) {
        let takeARSessionSnapshotButton = TakeSnapshotButton()
        view.insertSubview(takeARSessionSnapshotButton, at: view.subviews.count - 1)
        takeARSessionSnapshotButton.targetView = targetView
        NSLayoutConstraint.activate([
            takeARSessionSnapshotButton.widthAnchor.constraint(equalToConstant: 60),
            takeARSessionSnapshotButton.heightAnchor.constraint(equalToConstant: 50),
            takeARSessionSnapshotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            takeARSessionSnapshotButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    func createNavBar(title: String = .empty, rightButtons: [Object3DButton] = []) {
        if !isNavigationBarVisible { return }
        
        let navBar = UIHostingController(rootView: NavBar(object3DButtons: rightButtons,
                                                          title: title) { [unowned self] in
            dismiss(animated: false, completion: nil)
        })
        navBar.view.backgroundColor = .clear
        addChild(navBar)
        view.addSubview(navBar.view)
        navBar.view.translatesAutoresizingMaskIntoConstraints = false
        navBar.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        navBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        navBar.view.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
