
//
//  FilterViewController.swift
//  Cartify
//
//  Created by Mustafa on 28.12.2024.
//

import UIKit
protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(filters: [String: Any])
}

final class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    private var viewModel: ProductListViewModel 
    
    private var selectedSorting: String?
    private var selectedBrands: Set<String> = []
    private var selectedModels: Set<String> = []
    
    private let sortingOptions = ["Old to New", "New to Old", "Price High to Low", "Price Low to High"]
    private var brands: [String] {
        Array(Set(viewModel.products.map { $0.brand }))
    }
    private var models: [String] {
        Array(Set(viewModel.products.map { $0.model }))
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filters"
        view.backgroundColor = .white
        setupTableViewAndButton()
    }
    
    private func setupTableViewAndButton() {
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -10)
        ])
    }
    
    @objc private func applyFilters() {
        let filters: [String: Any] = [
            "sorting": selectedSorting as Any,
            "brands": Array(selectedBrands),
            "models": Array(selectedModels)
        ]
        delegate?.didApplyFilters(filters: filters)
        dismiss(animated: true)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return sortingOptions.count
        case 1: return brands.count
        case 2: return models.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = sortingOptions[indexPath.row]
            cell.accessoryType = sortingOptions[indexPath.row] == selectedSorting ? .checkmark : .none
        case 1:
            let brand = brands[indexPath.row]
            cell.textLabel?.text = brand
            cell.accessoryType = selectedBrands.contains(brand) ? .checkmark : .none
        case 2:
            let model = models[indexPath.row]
            cell.textLabel?.text = model
            cell.accessoryType = selectedModels.contains(model) ? .checkmark : .none
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            selectedSorting = sortingOptions[indexPath.row]
        case 1:
            let brand = brands[indexPath.row]
            if selectedBrands.contains(brand) {
                selectedBrands.remove(brand)
            } else {
                selectedBrands.insert(brand)
            }
        case 2:
            let model = models[indexPath.row]
            if selectedModels.contains(model) {
                selectedModels.remove(model)
            } else {
                selectedModels.insert(model)
            }
        default: break
        }
        tableView.reloadData()
    }
}
