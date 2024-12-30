//
//  FilterCellView.swift
//  Cartify
//
//  Created by Mustafa on 29.12.2024.
//

import UIKit

final class FilterCellView: UITableViewCell {
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square"), for: .normal) // Unchecked state
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected) // Checked state
        button.tintColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(filterLabel)
        contentView.addSubview(checkboxButton)
        
        NSLayoutConstraint.activate([
            filterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            checkboxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkboxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        checkboxButton.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
    }
    
    @objc private func didTapCheckbox() {
        checkboxButton.isSelected.toggle()
    }
    
    func configure(filterName: String, isChecked: Bool) {
        filterLabel.text = filterName
        checkboxButton.isSelected = isChecked
    }
}


