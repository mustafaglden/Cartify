//
//  SpinnerView.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//

import UIKit

final class SpinnerView {
    private var spinner: UIActivityIndicatorView?

    func show(on view: UIView) {
        DispatchQueue.main.async {
            if self.spinner == nil {
                let spinner = UIActivityIndicatorView(style: .large)
                spinner.color = .blue
                spinner.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(spinner)
                NSLayoutConstraint.activate([
                    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
                spinner.startAnimating()
                self.spinner = spinner
            }
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.spinner?.stopAnimating()
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }
}
