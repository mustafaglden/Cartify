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
        button.backgroundColor = UIColor(named: "grayColor")
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let appliedFiltersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        
        // Set explicit properties for the label and button
        appliedFiltersLabel.text = "No Filters Applied"
        appliedFiltersLabel.font = UIFont.systemFont(ofSize: 14)
        appliedFiltersLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        filterButton.setTitle("Select Filter", for: .normal)
        filterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        filterButton.backgroundColor = UIColor(named: "grayColor")
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        filterButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        filterStackView.addArrangedSubview(appliedFiltersLabel)
        filterStackView.addArrangedSubview(filterButton)
        
        view.addSubview(filterStackView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarContainer.heightAnchor.constraint(equalToConstant: 40),
            
            searchBar.topAnchor.constraint(equalTo: searchBarContainer.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchBarContainer.bottomAnchor),
            
            filterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            filterButton.heightAnchor.constraint(equalToConstant: 36),
            
            filterStackView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 8),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
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
            collectionView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
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
        //Couldn't fix it yet.
        let filterVC = FilterViewController(viewModel: viewModel)
        filterVC.modalPresentationStyle = .pageSheet
        filterVC.delegate = self
        let navigationController = UINavigationController(rootViewController: filterVC)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func addToCartTappedCollectionView(product: ProductElement) {
        if CoreDataManager.shared.isProductInCart(productId: product.id) {
            CoreDataManager.shared.incrementProductQuantity(productId: product.id)
        } else {
            CoreDataManager.shared.saveToCart(product: product, quantity: 1)
        }
        updateBadgeTabBar()
    }
}

//MARK: - Extensions
extension ProductListingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredProducts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellView", for: indexPath) as? ProductCellView else {
            return UICollectionViewCell()
        }
        let product = viewModel.filteredProducts[indexPath.row]
        if let imageUrl = URL(string: product.image) {
            let isFav = CoreDataManager.shared.isFavorite(productId: product.id)
            cell.configure(with: imageUrl, title: product.name, price: product.price, showStar: isFav) {
                [weak self] in
                guard let self else { return }
                self.addToCartTappedCollectionView(product: product)
            }
        }
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 16
        return CGSize(width: width, height: 300)
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
        
        var filterSummary = "Applied Filters: "
        if let brands = filters["brands"] as? [String], !brands.isEmpty {
            filterSummary += "Brands: \(brands.joined(separator: ", ")) "
        }
        if let models = filters["models"] as? [String], !models.isEmpty {
            filterSummary += "Models: \(models.joined(separator: ", ")) "
        }
        if let sorting = filters["sorting"] as? String {
            filterSummary += "Sorting: \(sorting) "
        }
        appliedFiltersLabel.text = filterSummary.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
