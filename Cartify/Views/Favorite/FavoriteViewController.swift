//
//  FavoriteViewController.swift
//  Cartify
//
//  Created by Mustafa on 28.12.2024.
//

import UIKit

final class FavoriteViewController: BaseViewController {

    var favoriteProducts: [CoreDataProduct] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteCellView.self, forCellReuseIdentifier: "FavoriteCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabelText = "Favorites"

        setupUI()
        fetchFavoriteProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteProducts()
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchFavoriteProducts() {
        favoriteProducts = CoreDataManager.shared.fetchAllFavorites()
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCellView
        let product = favoriteProducts[indexPath.row]
        if let imageURL = URL(string: product.image ?? "") {
            cell.configure(with: imageURL, title: product.name ?? "", price: product.price ?? "")
        }
        return cell
    }
}
