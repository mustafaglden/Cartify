//
//  ShoppingCartViewController.swift
//  Cartify
//
//  Created by Mustafa on 28.12.2024.
//

import UIKit

final class ShoppingCartViewController: BaseViewController {
    private(set) var cartProducts: [CoreDataCartProduct] = []
    private let tableView = UITableView()
    private let bottomView = PriceAndButtonBottomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleLabelText = "E-Market"
        setupViews()
        loadCartProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCartProducts()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.register(CartCellView.self, forCellReuseIdentifier: CartCellView.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    private func loadCartProducts() {
        cartProducts = CoreDataManager.shared.fetchAllCartProducts()
        tableView.reloadData()
        let totalPrice = calculateTotalPrice()
        bottomView.configure(buttonText: "Complete Purchase", priceText: String(format: "%.2f", totalPrice), forCartVC: true) {
            print("Complete purchase.")
        }
    }
    
    private func calculateTotalPrice() -> Double {
        return cartProducts.reduce(0) { total, product in
            let price = Double(product.price!)
            return total + (price! * Double(product.quantity))
        }
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCellView.identifier, for: indexPath) as? CartCellView else {
            return UITableViewCell()
        }
        let cartProduct = cartProducts[indexPath.row]
        cell.configure(with: cartProduct)
        cell.delegate = self
        return cell
    }
}

extension ShoppingCartViewController: CartCellViewDelegate {
    func didUpdateQuantity(for productId: String, newQuantity: Int) {
        guard let product = cartProducts.first(where: { $0.id == productId }) else { return }
        
        if newQuantity == 0 {
            CoreDataManager.shared.delete(product)
            print(cartProducts)
            if let index = cartProducts.firstIndex(of: product) {
                cartProducts.remove(at: index)
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        } else {
            product.quantity = Int32(newQuantity)
            CoreDataManager.shared.saveContext()
            if let index = cartProducts.firstIndex(of: product) {
                tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
        let totalPrice = calculateTotalPrice()
        bottomView.configure(
            buttonText: "Complete Purchase",
            priceText: String(format: "%.2f", totalPrice),
            forCartVC: true
        ) {
            print("Complete purchase")
        }
        
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.updateTabBarBadge()
        }
    }
}

