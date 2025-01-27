//
//  TabBarController.swift
//  Catsby
//
//  Created by Lee Wonsun on 1/27/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTabBarController()
        setAppearnce()
    }
    
    private func configTabBarController() {
        let firstVC = UINavigationController(rootViewController: TodayMovieViewController())
        firstVC.tabBarItem.title = "CINEMA"
        firstVC.tabBarItem.image = UIImage(systemName: "popcorn")
        
        let secondVC = UINavigationController(rootViewController: UpcomingViewController())
        secondVC.tabBarItem.title = "UPCOMING"
        secondVC.tabBarItem.image = UIImage(systemName: "film.stack")
        
        let thirdVC = UINavigationController(rootViewController: SettingViewController())
        thirdVC.tabBarItem.title = "PROFILE"
        thirdVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        setViewControllers([firstVC, secondVC, thirdVC], animated: true)
    }
    
    private func setAppearnce() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .catsBlack
        tabBar.tintColor = .catsMain
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
