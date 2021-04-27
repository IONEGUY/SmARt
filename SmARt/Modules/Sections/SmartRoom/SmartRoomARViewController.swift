//
//  SmartRoomARViewController.swift
//  SmARt
//
//  Created by MacBook on 27.04.21.
//

import Foundation
import UIKit
import Closures

class SmartRoomARViewController: GeneralARViewController<SmartRoomARViewModel> {
    private let objects3DButtonsContainer: UIStackView = {
        let container = UIStackView()
        container.backgroundColor = UIColor(hex: "#C4C4C4", alpha: 0.7)
        container.layer.cornerRadius = 8
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private var object3DButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.current3DObjectChanged
            .sink { [unowned self] _ in
                viewModel.object3DButtons.enumerated().forEach { (index, item) in
                    object3DButtons[index].setImage(UIImage(named: item.currentImage), for: .normal)
                }
            }
            .store(in: &cancellables)
    }
    
    private func create3DObjectsButtons() {
        viewModel.object3DButtons.forEach {
            let button = UIButton()
            button.setImage(UIImage(named: $0.currentImage), for: .normal)
            button.onTap(handler: $0.action)
            objects3DButtonsContainer.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            object3DButtons.append(button)
        }
    }
    
    override func addTakeSnapshotButton(of targetView: UIView) {
        navBar.appendViewToRightSide(objects3DButtonsContainer)
        create3DObjectsButtons()
        objects3DButtonsContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        object3DButtons.forEach { $0.heightAnchor.constraint(equalToConstant: 30).isActive = true }
        
        super.addTakeSnapshotButton(of: targetView)
        
        view.layoutSubviews()
        view.layoutIfNeeded()
    }
}
