//
//  CartCellView.swift
//  Cartify
//
//  Created by Mustafa on 29.12.2024.
//
import UIKit

protocol CartCellViewDelegate: AnyObject {
    func didUpdateQuantity(for productId: String, newQuantity: Int)
}

final class CartCellView: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "CartCellView"
    
    weak var delegate: CartCellViewDelegate?
    
    private var productId: String?
    private var quantity: Int = 1 {
        didSet {
            quantityLabel.text = "\(quantity)"
        }
    }
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.text = "1"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(decrementQuantity), for: .touchUpInside)
        return button
    }()
    
    private let incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(incrementQuantity), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        quantity = 1
        productId = nil
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(decrementButton)
        contentView.addSubview(incrementButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: decrementButton.leadingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            decrementButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -8),
            decrementButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            decrementButton.widthAnchor.constraint(equalToConstant: 40),
            decrementButton.heightAnchor.constraint(equalToConstant: 40),

            quantityLabel.trailingAnchor.constraint(equalTo: incrementButton.leadingAnchor, constant: -8),
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),

            incrementButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            incrementButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            incrementButton.widthAnchor.constraint(equalToConstant: 40),
            incrementButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - Configuration Method
    func configure(with product: CoreDataCartProduct) {
        self.productId = product.id
        self.quantity = Int(product.quantity)
        titleLabel.text = product.name
    }
    
    // MARK: - Actions
    @objc private func incrementQuantity() {
        guard let productId = productId else { return }
        quantity += 1
        print("incremented")
        delegate?.didUpdateQuantity(for: productId, newQuantity: quantity)
    }
    
    @objc private func decrementQuantity() {
        guard let productId = productId else { return }
        if quantity > 0 {
            quantity -= 1
            print("decremented")
            delegate?.didUpdateQuantity(for: productId, newQuantity: quantity)
        }
    }
}
