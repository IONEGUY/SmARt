//
//  InteractionMessage.swift
//  SmARt
//
//  Created by MacBook on 22.04.21.
//

import Foundation
import UIKit

class InteractionMessage: UIView {
    private let messageHorizontalMargin: CGFloat = 20
    private let messageVerticalMargin: CGFloat = 8
    private let clickingImageTopMargin: CGFloat = 28
    private let clickingImageSideSize: CGFloat = 34
    
    var message: String = .empty {
        didSet {
            messageLabel.text = message
            layoutIfNeeded()
        }
    }
    
    private let clickingImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "clicking"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageContainer: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 9
        container.backgroundColor = UIColor(hex: "#1C1C1C", alpha: 0.54)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(clickingImage)
        addSubview(messageContainer)
        messageContainer.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //messageContainer
            messageContainer.topAnchor.constraint(equalTo: topAnchor),
            messageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            //messageLabel
            messageLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: messageHorizontalMargin),
            messageLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -messageHorizontalMargin),
            messageLabel.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: messageVerticalMargin),
            messageLabel.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -messageVerticalMargin),
            //clickingImage
            clickingImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            clickingImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            clickingImage.topAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: clickingImageTopMargin),
            clickingImage.widthAnchor.constraint(equalToConstant: clickingImageSideSize),
            clickingImage.heightAnchor.constraint(equalToConstant: clickingImageSideSize)
        ])
    }
}
