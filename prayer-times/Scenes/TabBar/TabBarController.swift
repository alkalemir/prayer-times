//
//  TabBarController.swift
//  PrayerTimes
//
//  Created by Emir Alkal on 13.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
    }
    
    private func setupControllers() {
        let vc1 = PrayerTimesController()
        vc1.tabBarItem.title = "Ezan Vakitleri"
        vc1.tabBarItem.image = UIImage(named: "Pray Times")
        
        let vc2 = QiblaFinderController()
        vc2.tabBarItem.title = "Kıble Bulucu"
        vc2.tabBarItem.image = UIImage(named: "Compass")
        
//        let vc3 = UIViewController()
//        vc3.tabBarItem.title = "Sure ve Dua"
//        vc3.tabBarItem.image = UIImage(named: "Surahs")
//
//        let vc4 = UIViewController()
//        vc4.tabBarItem.title = "40 Hadis"
//        vc4.tabBarItem.image = UIImage(named: "40 Hadith")
        
        let vc5 = SettingsVC()
        vc5.tabBarItem.title = "Ayarlar"
        vc5.tabBarItem.image = UIImage(named: "Settings")
        
        viewControllers = [
            vc1, vc2, vc5
        ]
        
        tabBar.tintColor = .selectedTint
        tabBar.unselectedItemTintColor = .unselectedTint
        tabBar.backgroundColor = .white
        setUnselectedItems(for: tabBar)
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = .init(width: -0.5, height: -0.5)
    }
    
    private func setUnselectedItems(for tabBar: UITabBar) {
        tabBar.items?.forEach {
            $0.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont.ceraMedium(size: 10)
            ], for: .normal)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setUnselectedItems(for: tabBar)
        
        item.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.ceraBold(size: 10)
        ], for: .normal)
    }
}
