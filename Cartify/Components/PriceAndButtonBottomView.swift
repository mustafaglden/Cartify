//
//  ShoppingCartBottomContainerView.swift
//  Cartify
//
//  Created by Mustafa on 29.12.2024.
//

import UIKit

final class ShoppingCartBottomContainerView: UIView {
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    var buttonAction: (() -> Void)?
        
    // MARK: - Setup
    private func setupView() {
        addSubview(priceLabel)
        addSubview(bottomButton)
        setupConstraints()
        
        bottomButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: bottomButton.leadingAnchor, constant: -16),
                
            bottomButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            bottomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bottomButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            bottomButton.widthAnchor.constraint(equalToConstant: 182),
            bottomButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
    
    func configure(buttonText: String, priceText: String, buttonAction: @escaping () -> Void) {
        priceLabel.text = priceText
        bottomButton.setTitle(buttonText, for: .normal)
        self.buttonAction = buttonAction
    }
}
