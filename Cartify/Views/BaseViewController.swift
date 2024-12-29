//
//  BaseViewController.swift
//  Cartify
//
//  Created by Mustafa on 28.12.2024.
//

import UIKit

class BaseViewController: UIViewController {
    let navTitleLabel = UILabel()
    let titleView = UIView()
    
    var titleLabelText: String = "" {
        didSet {
            updateCustomTitleView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTitleView()
    }

    private func setupCustomTitleView() {
        // Configure the titleView
        titleView.backgroundColor = .clear
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the label
        navTitleLabel.text = titleLabelText
        navTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        navTitleLabel.textColor = .black
        navTitleLabel.textAlignment = .center
        navTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add label to the titleView
        titleView.addSubview(navTitleLabel)

        // Set up constraints for navTitleLabel within titleView
        NSLayoutConstraint.activate([
            navTitleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            navTitleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            navTitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            navTitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
        
        // Assign the titleView as the custom title view
        navigationItem.titleView = titleView
    }
    
    private func updateCustomTitleView() {
        navTitleLabel.text = titleLabelText
    }
}
