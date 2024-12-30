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
    
    private let productImage = UIImageView()
    private let descriptionLabel = UILabel()
    private let titleLabel = UILabel()
    private let starButton = UIButton()
    
    private let bottomView = PriceAndButtonBottomView()
    
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
        view.addSubview(bottomView)
        view.addSubview(titleLabel)
        
        productImage.contentMode = .scaleToFill
        productImage.clipsToBounds = true
        productImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        starButton.tintColor = UIColor(named: "grayColor")
        starButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        starButton.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func updateUI() {
        guard let product = currentProduct else { return }
        if let imageUrl = URL(string: product.image) {
            productImage.loadImage(from: imageUrl)
        }
        titleLabel.text = product.name
        bottomView.configure(buttonText: "Add to Cart", priceText: product.price) { [weak self] in
            guard let self else { return }
            self.addToCartTapped()
        }
        descriptionLabel.text = product.description
    }
    
    private func loadFavoriteStatus() {
        guard let product = currentProduct else { return }
        isFavorite = CoreDataManager.shared.isFavorite(productId: product.id)
    }
    
    private func updateStarButtonAppearance() {
        starButton.tintColor = isFavorite ? UIColor(named: "yellowColor"): UIColor(named: "grayColor")
    }
    
    private func addToCartTapped() {
        guard let product = currentProduct else { return }
        
        if CoreDataManager.shared.isProductInCart(productId: product.id) {
            CoreDataManager.shared.incrementProductQuantity(productId: product.id)
            print("increment by one")
        } else {
            CoreDataManager.shared.saveToCart(product: product, quantity: 1)
            print("decrement by one")
        }
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
}
