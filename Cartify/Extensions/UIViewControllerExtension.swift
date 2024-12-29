//
//  UIViewControllerExtension.swift
//  Cartify
//
//  Created by Mustafa on 28.12.2024.
//

import UIKit

extension UIViewController {
    func showAlert(
        _ message: String,
        title: String = "Error",
        actionButtonTitle: String = "OK",
        actionButtonHandler: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionButtonTitle, style: .default) { _ in
            actionButtonHandler?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
