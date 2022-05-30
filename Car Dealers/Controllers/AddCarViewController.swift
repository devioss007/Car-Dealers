//
//  AddCarViewController.swift
//  Car Dealers
//
//  Created by dev ios on 28/05/22.
//

import UIKit

class AddCarViewController: UIViewController {
    let bottomLineView = UIView()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 4.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.textColor = .label.withAlphaComponent(0.8)
        textField.placeholder = "Enter your car brand"
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.returnKeyType = .done
        return textField
    }()
    
    private let placecholderText = "Enter your car dealer locations..."
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Enter your car dealer locations..."
        textView.textColor = .label.withAlphaComponent(0.8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 4.0
        textView.textColor = .gray
        textView.autocorrectionType = .no
        textView.returnKeyType = .done
        textView.font = UIFont(name: "ArialMT", size: 16)
        return textView
    }()
    
    private var mySegmentedControl: UISegmentedControl = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()

        view.addSubview(textField)
        view.addSubview(textView)
        textField.delegate = self
        textView.delegate = self
        configureSegmentedControl()
        view.addSubview(bottomLineView)

        setupUI()
        createDismissKeyboardTapGesture()
    }
    let dict = [0: "petrol", 1: "diesel", 2: "electric"]
    private func configureSegmentedControl() {
        let items = ["Petrol🚙", "Diesel🚚", "Electric🔌"]
        mySegmentedControl = UISegmentedControl (items: items)
        view.addSubview(mySegmentedControl)
        mySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        mySegmentedControl.selectedSegmentIndex = 0
        mySegmentedControl.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
        title = "Add New Car"
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem   = leftButton
        
        navigationController?.navigationBar.barTintColor = UIColor.gray
        
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.backgroundColor = .gray.withAlphaComponent(0.2)
    }
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            textView.heightAnchor.constraint(equalToConstant: 160),
            
            mySegmentedControl.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            mySegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            mySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            mySegmentedControl.heightAnchor.constraint(equalToConstant: 35),
            
            bottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.frame = CGRect(x: 20, y: topbarHeight + 30, width: UIScreen.main.bounds.width - 40, height: 34)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func saveButtonTapped() {
        if textField.text!.isEmpty || textView.text == placecholderText || textView.text == "" {
            showAlert(title: "Pleace enter text in empty field!") { }
        } else {
            self.textField.resignFirstResponder()
            self.textView.resignFirstResponder()
            
            let newItem = Car(name: self.textField.text!, locations: self.textView.text, imageName: "defaultImage", thumbnailName: "defaultImage", type: dict[mySegmentedControl.selectedSegmentIndex] ?? "all")
            
            PersistenceManager.retrive(key: Keys.addedCars) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let oldItems):
                    PersistenceManager.save(key: Keys.addedCars, items: oldItems + [newItem])
                    self.showAlert(title: "You added New car dealer successfully!") {
                        self.dismiss(animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
}


extension AddCarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async { textField.resignFirstResponder() }
        return true
    }
}

extension AddCarViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.textColor = .label.withAlphaComponent(0.8)
        if placecholderText == textView.text {
            textView.text = ""
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = placecholderText
            textView.textColor = .gray
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.contains("\n") {
            DispatchQueue.main.async { textView.resignFirstResponder() }
            textView.text.removeLast()
        }
    }
}


