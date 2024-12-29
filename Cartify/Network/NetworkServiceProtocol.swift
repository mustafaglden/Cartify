//
//  NetworkServiceProtocol.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//

protocol NetworkServiceProtocol {
    func fetchProducts(completion: @escaping (Result<Product, NetworkError>) -> Void)
}
