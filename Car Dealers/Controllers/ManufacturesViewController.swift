//
//  ManufacturesViewController.swift
//  Car Dealers
//
//  Created by dev ios on 28/05/22.
//

import UIKit

protocol NoticeActionInCell: AnyObject {
    func openDetailViewController(with model: Car)
    func showAlert(_ message: String)
}

final class ManufacturesViewController: UIViewController {
    
    private var mySegmentedControl = UISegmentedControl()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ManufactureTableViewCell.self, forCellReuseIdentifier: ManufactureTableViewCell.identifier)
        return tableView
    }()
    
    var cars: [Car] = []
    var persistentCars: [Car] = []
    var filteredCars: [Car] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSegmentedControl()
        parsingJson()
        PersistenceManager.retrive(key: Keys.addedCars) { result in
            switch result {
            case .success(let oldItem):
                self.persistentCars = oldItem
                self.filteredCars = self.cars + self.persistentCars
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        configureTableView()
    }
    
    private func parsingJson() {
        if let data = getData() {
            do {
                cars = try JSONDecoder().decode([Car].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
        title                = "Car Dealers"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
    private func getData() -> Data? {
        do {
            if let bundlePath   = Bundle.main.path(forResource: "cars", ofType: "json") {
                let jsonData    = try String(contentsOfFile: bundlePath).data(using: .utf8)
                return jsonData
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PersistenceManager.retrive(key: Keys.addedCars) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let oldItem):
                self.mySegmentedControl.selectedSegmentIndex = 0
                self.persistentCars = oldItem
                self.filteredCars  = self.cars + self.persistentCars
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureSegmentedControl() {
        let items = ["All🚘", "Petrol🚙", "Diesel🚚", "Electric🔌"]
        mySegmentedControl = UISegmentedControl (items: items)
        view.addSubview(mySegmentedControl)
        mySegmentedControl.selectedSegmentIndex = 0
        mySegmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: mySegmentedControl.bottomAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mySegmentedControl.frame = CGRect(x: 10, y: topbarHeight, width: UIScreen.main.bounds.width - 20, height: 35)
    }
    
    let sections: [Int: String] = [0: "all", 1: "petrol", 2: "diesel", 3: "electric"]
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        filteredCars = index == 0 ? cars + persistentCars : (cars + persistentCars).filter { $0.type == sections[index] }
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    @objc func addButtonTapped() {
        let nc = UINavigationController(rootViewController: AddCarViewController())
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }
}


extension ManufacturesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ManufactureTableViewCell.identifier, for: indexPath) as? ManufactureTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredCars[indexPath.row])
        cell.setupGestures()
        cell.noticeActions(delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    }
}

extension ManufacturesViewController: NoticeActionInCell {
    func showAlert(_ message: String) {
        showAlert(title: message) { }
    }
    
    func openDetailViewController(with model: Car) {
        present(UINavigationController(rootViewController: DetailViewController(with: model)), animated: true)
    }
}


