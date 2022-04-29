//
//  AppDelegate.swift
//  Weather
//
//  Created by Nirmal's Macbook Pro on 29/04/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navgiationController = UINavigationController()
        let blueViewController = WeatherViewController(style: .grouped)
        navgiationController.pushViewController(blueViewController, animated: false)
        window!.rootViewController = navgiationController
        window!.makeKeyAndVisible()
        
        return true
    }
}
