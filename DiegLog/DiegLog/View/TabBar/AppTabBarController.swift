//
//  AppTabBarController.swift
//  DiegLog
//
//  Created by Jooyeon Kang on 2024/04/04.
//

import UIKit

class AppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarUI()
        
        let melaView = MealViewController()
        let myInfoView = MyInfoViewController()
        let exerciseView = CategoryViewController()
        let searchView = SearchViewController()
        
        melaView.tabBarItem = UITabBarItem(title: AppTabBarItem.meal.toTabTitle(),
                                           image: AppTabBarItem.meal.toTabImage(),
                                           tag: AppTabBarItem.meal.rawValue)
        
        myInfoView.tabBarItem = UITabBarItem(title: AppTabBarItem.myInfo.toTabTitle(),
                                             image: AppTabBarItem.myInfo.toTabImage(),
                                             tag: AppTabBarItem.myInfo.rawValue)
        
        exerciseView.tabBarItem = UITabBarItem(title: AppTabBarItem.exercise.toTabTitle(),
                                               image: AppTabBarItem.exercise.toTabImage(),
                                               tag: AppTabBarItem.exercise.rawValue)
        
        searchView.tabBarItem = UITabBarItem(title: AppTabBarItem.search.toTabTitle(),
                                               image: AppTabBarItem.search.toTabImage(),
                                               tag: AppTabBarItem.search.rawValue)
        
        searchView.tabBarItem.imageInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        
        let mealNavigationController = UINavigationController(rootViewController: melaView)
        let myInfoNavigationController = UINavigationController(rootViewController: myInfoView)
        let exerciseNavigationController = UINavigationController(rootViewController: exerciseView)
        
        viewControllers = [mealNavigationController,
                           myInfoNavigationController,
                           exerciseNavigationController,
                           searchView]
        
        selectedViewController = myInfoNavigationController
    }
}

extension AppTabBarController {
    
    private func setTabBarUI() {
        tabBar.tintColor = .customGreen
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .white
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 2
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: UIFont(name: FontName.regular, size: 10)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    }
}
