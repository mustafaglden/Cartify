//
//  UIImageViewExtension.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
