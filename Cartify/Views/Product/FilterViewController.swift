
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

    private var searchTextBrands: String = ""
    private var searchTextModels: String = ""

    private let sortingOptions = ["Old to New", "New to Old", "Price High to Low", "Price Low to High"]
    private var filteredBrands: [String] {
        searchTextBrands.isEmpty ? brands : brands.filter { $0.lowercased().contains(searchTextBrands.lowercased()) }
    }
    private var filteredModels: [String] {
        searchTextModels.isEmpty ? models : models.filter { $0.lowercased().contains(searchTextModels.lowercased()) }
    }
    private var brands: [String] {
        Array(Set(viewModel.products.map { $0.brand })).sorted()
    }
    private var models: [String] {
        Array(Set(viewModel.products.map { $0.model })).sorted()
    }

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filter", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "blueColor") ?? .blue
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
        title = "Filter"
//        navigationController?.navigationItem.leftBarButtonItem?
        view.backgroundColor = .white
        setupTableViewAndButton()
    }

    private func setupTableViewAndButton() {
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterCellView.self, forCellReuseIdentifier: "FilterCell")
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
        case 1: return filteredBrands.count
        case 2: return filteredModels.count
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterCellView else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            let sortingOption = sortingOptions[indexPath.row]
            let isChecked = sortingOption == selectedSorting
            cell.configure(filterName: sortingOption, isChecked: isChecked)
        case 1:
            let brand = filteredBrands[indexPath.row]
            let isChecked = selectedBrands.contains(brand)
            cell.configure(filterName: brand, isChecked: isChecked)
        case 2:
            let model = filteredModels[indexPath.row]
            let isChecked = selectedModels.contains(model)
            cell.configure(filterName: model, isChecked: isChecked)
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
            let brand = filteredBrands[indexPath.row]
            if selectedBrands.contains(brand) {
                selectedBrands.remove(brand)
            } else {
                selectedBrands.insert(brand)
            }
        case 2:
            let model = filteredModels[indexPath.row]
            if selectedModels.contains(model) {
                selectedModels.remove(model)
            } else {
                selectedModels.insert(model)
            }
        default: break
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.font = .boldSystemFont(ofSize: 16)
        header.textColor = .darkGray
        switch section {
        case 0: header.text = "  Sort By"
        case 1: header.text = "  Brand"
        case 2: header.text = "  Model"
        default: break
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
