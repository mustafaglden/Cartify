//
//  MainTabBarController.swift
//  Cartify
//
//  Created by Mustafa on 27.12.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = .systemBlue
        
        let productlistVC = UINavigationController(rootViewController: ProductListingViewController())
        productlistVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
                
        let cartVC = UINavigationController(rootViewController: ShoppingCartViewController())
        cartVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "basket"), tag: 1)
        
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        favoriteVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "star"), tag: 2)
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 3)
        
        viewControllers = [productlistVC, cartVC, favoriteVC, profileVC]
    }
}
