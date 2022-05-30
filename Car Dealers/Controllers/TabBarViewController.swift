//
//  MainTabBarViewController.swift
//  Car Dealers
//
//  Created by dev ios on 28/05/22.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: ManufacturesViewController())
        let vc2 = UINavigationController(rootViewController: FavouritesViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "list.bullet")
        vc2.tabBarItem.image = UIImage(systemName: "star.fill")
        
        vc1.title = "Manufactures"
        vc2.title = "Favourites"
        
        setViewControllers([vc1, vc2], animated: true)
        
        tabBar.isTranslucent   = false
        tabBar.backgroundColor = .systemGray5
    }
}
