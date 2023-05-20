//
//  SceneDelegate.swift
//  prayer-times
//
//  Created by Emir Alkal on 19.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var isDidEnterBackground = false
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = TabBarController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        showAlert()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if isDidEnterBackground {
            let mainTabBar = window!.rootViewController as! TabBarController
            let prayerTimesVC = mainTabBar.viewControllers![0] as! PrayerTimesController
            prayerTimesVC.viewModel.fetchTimes()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        showAlert()
        isDidEnterBackground = true
        let mainTabBar = window!.rootViewController as! TabBarController
        let prayerTimesVC = mainTabBar.viewControllers![0] as! PrayerTimesController
        prayerTimesVC.prayerTimesView?.timer?.invalidate()
    }
    
    private func showAlert() {
        if let timeName = UserDefaults.standard.string(forKey: "timeName") {
            let remainTime = UserDefaults.standard.integer(forKey: "remainTime")
            let content = UNMutableNotificationContent()
            let notificationOffset = UserDefaults.standard.integer(forKey: "timeInterval")
            let minute: Int
            if notificationOffset == 900 {
                minute = 15
            } else if notificationOffset == 1800 {
                minute = 30
            } else if notificationOffset == 45 * 60 {
                minute = 45
            } else {
                minute = 0
            }
            content.title = "\(timeName) namazı yaklaşıyor!"
            content.body = "\(minute) dakika sonra \(timeName) ezanı okunacak."
            content.sound = .default
            print(notificationOffset)
            if remainTime >= notificationOffset {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(remainTime - notificationOffset), repeats: false)
                let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

