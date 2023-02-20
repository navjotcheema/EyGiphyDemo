//
//  TabBarController.swift
//  EyDemo
//
//  Created by Navjot Cheema on 2023-02-15.
//

import UIKit

class TabBarController: UITabBarController {
    var tabBarViewModel: TabBarViewModel = TabBarViewModel()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                if let homeVC = viewController as? HomeViewController {
                    homeVC.tabBarViewModel = tabBarViewModel
                }
                if let favVc = viewController as? FavoritesViewController {
                    favVc.tabBarViewModel = tabBarViewModel
                }
            }
        }
    }
}
