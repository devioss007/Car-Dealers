//
//  LabelForName.swift
//  Car Dealers
//
//  Created by dev ios on 30/05/22.
//

import UIKit

class LabelForName: UILabel {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        backgroundColor = .white
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
