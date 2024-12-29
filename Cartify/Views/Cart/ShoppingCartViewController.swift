//
//  ShoppingCartViewController.swift
//  Cartify
//
//  Created by Mustafa on 28.12.2024.
//

import UIKit

final class ShoppingCartViewController: BaseViewController {
    
    private var cartProducts: [CoreDataCartProduct] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleLabelText = "E-Market"
        setupTableView()
        loadCartProducts()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(CartCellView.self, forCellReuseIdentifier: CartCellView.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func loadCartProducts() {
        cartProducts = CoreDataManager.shared.fetchAllCartProducts()
        tableView.reloadData()
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
        product.quantity = Int32(newQuantity)
        CoreDataManager.shared.saveContext()
        if let index = cartProducts.firstIndex(of: product) {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}
