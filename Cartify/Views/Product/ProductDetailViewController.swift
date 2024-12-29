//
//  ProductDetailViewController.swift
//  Cartify
//
//  Created by Mustafa on 28.12.2024.
//

import UIKit

final class ProductDetailViewController: BaseViewController {
    
    private var isFavorite: Bool = false {
        didSet {
            updateStarButtonAppearance()
        }
    }
    
    var currentProduct: ProductElement? {
        didSet {
            updateUI()
        }
    }
        
    private var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Add to Cart", for: .normal)
        button.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let productImage = UIImageView()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let titleLabel = UILabel()
    private let starButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        titleLabelText = "Product Detail"
        
        setupView()
        loadFavoriteStatus()
    }
    
    private func setupView() {
        view.addSubview(productImage)
        view.addSubview(starButton)
        view.addSubview(descriptionLabel)
        view.addSubview(priceLabel)
        view.addSubview(titleLabel)
        view.addSubview(addToCartButton)
        
        productImage.contentMode = .scaleToFill
        productImage.clipsToBounds = true
        productImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.textAlignment = .left
        priceLabel.textColor = .black
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        starButton.tintColor = .systemGray
        starButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            productImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            productImage.heightAnchor.constraint(equalToConstant: 200),
            
            starButton.heightAnchor.constraint(equalToConstant: 24),
            starButton.widthAnchor.constraint(equalToConstant: 24),
            starButton.topAnchor.constraint(equalTo: productImage.topAnchor, constant: 8),
            starButton.trailingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 16),
            
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 38),
            addToCartButton.widthAnchor.constraint(equalToConstant: 182),
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func updateUI() {
        guard let product = currentProduct else { return }
        if let imageUrl = URL(string: product.image) {
            productImage.loadImage(from: imageUrl)
        }
        titleLabel.text = product.name
        priceLabel.text = "$\(product.price)"
        descriptionLabel.text = product.description
    }
    
    private func loadFavoriteStatus() {
        guard let product = currentProduct else { return }
        isFavorite = CoreDataManager.shared.isFavorite(productId: product.id)
    }
    
    private func updateStarButtonAppearance() {
        starButton.tintColor = isFavorite ? .systemOrange : .systemGray
    }
    
    @objc private func toggleFavorite() {
        guard let product = currentProduct else { return }
        
        isFavorite.toggle()
        
        if isFavorite {
            CoreDataManager.shared.saveFavorite(product: product)
            print("add to favs")
        } else {
            CoreDataManager.shared.removeFavorite(productId: product.id)
            print("remove from favs")
        }
    }
    
    @objc private func addToCartTapped() {
        guard let product = currentProduct else { return }
        
        if CoreDataManager.shared.isProductInCart(productId: product.id) {
            CoreDataManager.shared.incrementProductQuantity(productId: product.id)
            print("1 unit of \(product.name) added to existing cart item.")
        } else {
            CoreDataManager.shared.saveToCart(product: product, quantity: 1)
            print("\(product.name) added to cart with quantity 1.")
        }
    }
    

}
