//
//  BaseViewController.swift
//  SmARt
//
//  Created by MacBook on 23.03.21.
//

import Foundation
import UIKit
import SwiftUI

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavBar()
    }
    
    func createNavBar(title: String = .empty, rightButtons: [Object3DButton] = []) {
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
