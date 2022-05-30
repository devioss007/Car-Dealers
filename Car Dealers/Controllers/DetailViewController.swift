//
//  DetailViewController.swift
//  Car Dealers
//
//  Created by dev ios on 28/05/22.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let imageView = MyImageView()
    private let nameLabel = LabelForName(fontSize: 26)
    
    private let locationsLabelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label.withAlphaComponent(0.7)
        label.text = "LOCATIONS"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let locationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label.withAlphaComponent(0.7)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    init(with model: Car) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: model.imageName)
        nameLabel.text = model.name
        locationsLabel.text = model.locations.formatString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureImageView()
    }

    private func configureImageView() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(locationsLabelTitle)
        view.addSubview(locationsLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            locationsLabelTitle.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationsLabelTitle.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            locationsLabelTitle.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            
            locationsLabel.topAnchor.constraint(equalTo: locationsLabelTitle.bottomAnchor, constant: 8),
            locationsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 6),
            locationsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
        ])
        
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "clear"), landscapeImagePhone: UIImage(systemName: "clear"), style: .done, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func addButtonTapped() {
        dismiss(animated: true)
    }
}

