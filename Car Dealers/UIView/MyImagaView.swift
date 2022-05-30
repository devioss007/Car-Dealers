//
//  MyImagaView.swift
//  Car Dealers
//
//  Created by dev ios on 29/05/22.
//

import UIKit

class MyImageView: UIImageView {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
