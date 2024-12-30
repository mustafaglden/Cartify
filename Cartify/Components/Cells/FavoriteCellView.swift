//
//  FavoriteCellView.swift
//  Cartify
//
//  Created by Mustafa on 30.12.2024.
//
import UIKit

final class FavoriteCellView: UITableViewCell {

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "price"
        label.textColor = UIColor(named: "blueColor")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(horizontalStack)
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(priceLabel)
        horizontalStack.addArrangedSubview(productImageView)
        horizontalStack.addArrangedSubview(verticalStack)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),

            verticalStack.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            verticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor)
        ])
    }

    func configure(with image: URL, title: String, price: String) {
        productImageView.loadImage(from: image)
        priceLabel.text = price + " ₺"
        titleLabel.text = title
    }
}
