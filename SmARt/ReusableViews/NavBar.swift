//
//  NavBar.swift
//  SmARt
//
//  Created by MacBook on 3.03.21.
//

import Foundation
import UIKit

class NavBar: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(hex: "#C4C4C4", alpha: 0.7)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var leftStackView = UIStackView()
    
    private var rightStackView = UIStackView()
    
    var title: String = .empty {
        didSet {
            titleLabel.text = title
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func appendViewToRightSide(_ view: UIView) {
        append(view: view, to: rightStackView)
    }
    
    func appendViewToLeftSide(_ view: UIView) {
        append(view: view, to: leftStackView)
    }
    
    private func append(view: UIView, to stackView: UIStackView) {
        stackView.addArrangedSubview(view)
        layoutSubviews()
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        setupStyleFor(for: leftStackView)
        setupStyleFor(for: rightStackView)
        
        addSubview(leftStackView)
        addSubview(rightStackView)
        addSubview(titleLabel)
        leftStackView.addArrangedSubview(backButton)
        
        backButton.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(backButtonPressed)))
    }
    
    private func setupStyleFor(for stackView: UIStackView) {
        stackView.spacing = 6
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //leftStackView
            leftStackView.topAnchor.constraint(equalTo: topAnchor),
            leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            //rightStackView
            rightStackView.topAnchor.constraint(equalTo: topAnchor),
            rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            //backButton
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            //title
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
        ])
    }
    
    @objc private func backButtonPressed() {
        let topViewController = UIApplication.getTopViewController()
        topViewController?.dismiss(animated: false)
        topViewController?.navigationController?.popViewController(animated: false)
    }
}
