//
//  ProductElement.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//

import Foundation

// MARK: - ProductElement
struct ProductElement: Codable {
    let createdAt, name: String
    let image: String
    let price, description, model, brand: String
    let id: String
}

typealias Product = [ProductElement]
