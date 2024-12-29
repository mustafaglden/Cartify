//
//  ProductListingViewController.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//

import UIKit

final class ProductListingViewController: BaseViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Filter", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGray
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let spinnerView = SpinnerView()
    
    private var searchBar = UISearchBar()
    private let searchBarContainer = UIView()
    
    private var viewModel = ProductListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleLabelText = "E-Market"
        // Do any additional setup after loading the view.
        setupSearchBar()
        setupCollectionView()
        setupBindings()
        setupFilterButton()
        viewModel.fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainer.backgroundColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainer.addSubview(searchBar)
            
        view.addSubview(searchBarContainer)
        view.addSubview(filterButton)

        NSLayoutConstraint.activate([
            searchBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarContainer.heightAnchor.constraint(equalToConstant: 40),
        
            searchBar.topAnchor.constraint(equalTo: searchBarContainer.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchBarContainer.bottomAnchor),
            
            filterButton.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 8),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
    }

    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCellView.self, forCellWithReuseIdentifier: "ProductCellView")
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupFilterButton() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didTapFilterButton))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func setupBindings() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                spinnerView.show(on: self.view)
            } else {
                spinnerView.hide()
            }
        }
        
        viewModel.onProductsFetched = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                print("Products fetched: \(self.viewModel.products.count)")
                self.collectionView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            guard let self else { return }
            self.showAlert(errorMessage)
        }
    }
    
    @objc private func didTapFilterButton() {
        let filterVC = FilterViewController(viewModel: viewModel)
        filterVC.modalPresentationStyle = .formSheet
        filterVC.delegate = self
        present(filterVC, animated: true, completion: nil)
    }
}

extension ProductListingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellView", for: indexPath) as? ProductCellView else {
            return UICollectionViewCell()
        }
        if let imageUrl = URL(string: viewModel.products[indexPath.row].image) {
            let isFav = CoreDataManager.shared.isFavorite(productId: viewModel.products[indexPath.row].id)
            // debug
            if indexPath.row == 1 {
                cell.configure(with: imageUrl, title: viewModel.products[indexPath.row].name, price: viewModel.products[indexPath.row].price, showStar: isFav)
            }
            cell.configure(with: imageUrl, title: viewModel.products[indexPath.row].name, price: viewModel.products[indexPath.row].price, showStar: isFav)
        }
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 16
        return CGSize(width: width, height: 200)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
        
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = ProductDetailViewController()
        detailVC.currentProduct = viewModel.products[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProductListingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchProducts(by: searchText)
    }
}

extension ProductListingViewController: FilterViewControllerDelegate {
    func didApplyFilters(filters: [String: Any]) {
        print("Applied filters: \(filters)")
        viewModel.applyFilters(filters)
        collectionView.reloadData()
    }
}
