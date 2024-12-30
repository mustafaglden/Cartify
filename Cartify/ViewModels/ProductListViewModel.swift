//
//  ProductListViewModel.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//

import Foundation

final class ProductListViewModel {
    
    var onLoadingStateChange: ((Bool) -> Void)?
    var onProductsFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var products: [ProductElement] = []
    private(set) var filteredProducts: [ProductElement] = []
    private var isFetching = false
    
    func fetchProducts() {
        guard !isFetching else { return }
        isFetching = true
        onLoadingStateChange?(true)
        
        NetworkService.shared.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                self?.isFetching = false
                self?.onLoadingStateChange?(false)
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.filteredProducts = products
                    self?.onProductsFetched?()
                case .failure(let error):
                    self?.onError?(self?.errorMessage(for: error) ?? "Unknown error")
                }
            }
        }
    }
    
    func searchProducts(by name: String) {
        if name.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { $0.name.localizedCaseInsensitiveContains(name) }
        }
        onProductsFetched?()
    }
    
    func applyFilters(_ filters: [String: Any]) {
        filteredProducts = products

        if let sorting = filters["sorting"] as? String {
            switch sorting {
            case "Old to New":
                filteredProducts.sort { $0.createdAt < $1.createdAt }
            case "New to Old":
                filteredProducts.sort { $0.createdAt > $1.createdAt }
            case "Price High to Low":
                filteredProducts.sort { $0.price > $1.price }
            case "Price Low to High":
                filteredProducts.sort { $0.price < $1.price }
            default:
                break
            }
        }
        if let brands = filters["brands"] as? [String], !brands.isEmpty {
            filteredProducts = filteredProducts.filter { brands.contains($0.brand) }
        }
        if let models = filters["models"] as? [String], !models.isEmpty {
            filteredProducts = filteredProducts.filter { models.contains($0.model) }
        }
        if filters.isEmpty {
            filteredProducts = products
        }
        onProductsFetched?()
    }
    
    private func errorMessage(for error: NetworkError) -> String {
        switch error {
        case .invalidURL: return "Invalid URL"
        case .requestFailed: return "Request failed. Please try again."
        case .decodingFailed: return "Data decoding failed."
        }
    }
}
