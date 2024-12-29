//
//  NetworkService.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {

    static let shared = NetworkService()
    private let baseURL = "https://5fc9346b2af77700165ae514.mockapi.io/products"
    
    func fetchProducts(completion: @escaping (Result<Product, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error)")
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let products = try JSONDecoder().decode(Product.self, from: data)
                completion(.success(products))
            } catch {
                print("Decoding failed with error: \(error)")
                completion(.failure(.decodingFailed))
            }
        }
        
        task.resume()
    }
}
