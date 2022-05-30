//
//  ManufactureTableViewCell.swift
//  Car Dealers
//
//  Created by dev ios on 28/05/22.
//

import UIKit

class ManufactureTableViewCell: UITableViewCell {
    static let identifier = "ManufactureTableViewCell"
    var item: Car!
    
    private let imageICon = MyImageView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let locationsLabel = LabelForName(fontSize: 14)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    weak var delegate: NoticeActionInCell!
    
    public func noticeActions(delegate: NoticeActionInCell) {
        self.delegate = delegate
    }

    public func configure(with model: Car) {
        imageICon.image = UIImage(named: model.imageName)
        nameLabel.text  = model.name
        locationsLabel.text = model.locations
        item = model
    }
    
    public func setupGestures() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTapGesture)
        
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    @objc func didDoubleTap() {
        PersistenceManager.retrive(key: Keys.favourites) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let oldFaourites):
                if oldFaourites.contains(where: { eachItem in eachItem.name == self.item.name }) {
                    self.delegate.showAlert("This dealer is already added!")
                } else {
                    PersistenceManager.save(key: Keys.favourites, items: oldFaourites + [self.item])
                    self.delegate.showAlert("This dealer is added successfully!")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func didPressSingleTap() {
        delegate.openDetailViewController(with: item)
    }
    
    private func setupUI() {
        contentView.addSubview(imageICon)
        contentView.backgroundColor = .white
        let stackView  = UIStackView(arrangedSubviews: [nameLabel, locationsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 1
        contentView.addSubview(stackView)
        
        let bottomLineView = UIView()
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.backgroundColor = .gray.withAlphaComponent(0.3)
        contentView.addSubview(bottomLineView)
        
        
        NSLayoutConstraint.activate([
            imageICon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageICon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageICon.widthAnchor.constraint(equalToConstant: 80),
            imageICon.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.leadingAnchor.constraint(equalTo: imageICon.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
