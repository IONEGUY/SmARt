//
//  LoadingView.swift
//  SmARt
//
//  Created by MacBook on 2.03.21.
//

import SwiftUI
import UIKit
import Combine

class LoadingViewWithProgressBar: UIView {
    var text: String = .empty {
        didSet {
            textLabel.text = text
            setNeedsDisplay()
        }
    }
    
    private var progressBar: ProgressBar = {
        let progressBar = ProgressBar()
        progressBar.gradientColor = .systemPink
        progressBar.color = .yellow
        return progressBar
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.font = .systemFont(ofSize: 15, weight: .ultraLight)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func updateProgress(_ progress: CGFloat) {
        progressBar.progress = progress
    }
    
    private func setup() {
        backgroundColor = .black
        layer.cornerRadius = 16

        addSubview(progressBar)
        addSubview(textLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: -30).isActive = true
    }
}
