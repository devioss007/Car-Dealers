//
//  Extensions.swift
//  Car Dealers
//
//  Created by dev ios on 29/05/22.
//

import UIKit

    // MARK: - UIViewController

extension UIViewController {
    func showAlert(title: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}


    // MARK: - String

extension String {
    var formatString: String {
        let toArray = self.components(separatedBy: ", ")
        let backToString = toArray.joined(separator: "\n")
        return backToString
    }
}


    // MARK: - UITextField

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
