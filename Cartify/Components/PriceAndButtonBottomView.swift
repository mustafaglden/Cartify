//
//  PriceAndButtonBottomView.swift
//  Cartify
//
//  Created by Mustafa on 29.12.2024.
//

import UIKit

final class PriceAndButtonBottomView: UIView {
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "blueColor")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(named: "blueColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let hstackContainer: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .center
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        stackview.spacing = 16
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
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
        hstackContainer.addArrangedSubview(priceLabel)
        hstackContainer.addArrangedSubview(bottomButton)
        addSubview(hstackContainer)
        
        NSLayoutConstraint.activate([
            hstackContainer.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hstackContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hstackContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            hstackContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        bottomButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
        print("custom view button tapped.")
    }
    
    func configure(buttonText: String, priceText: String, forCartVC: Bool = false, buttonAction: @escaping () -> Void) {
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor(named: "blueColor")]
        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]

        var attributedString1 = NSMutableAttributedString(string:"Price: ", attributes:attrs1 as [NSAttributedString.Key : Any])
        if forCartVC {
            attributedString1 = NSMutableAttributedString(string:"Total: ", attributes:attrs1 as [NSAttributedString.Key : Any])
        }
        let attributedString2 = NSMutableAttributedString(string:"\(priceText) ₺", attributes:attrs2)
        attributedString1.append(attributedString2)

        priceLabel.attributedText = attributedString1
        bottomButton.setTitle(buttonText, for: .normal)
        self.buttonAction = buttonAction
    }
}
