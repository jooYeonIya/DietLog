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
