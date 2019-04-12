//
//  Created by Alexander Gulin on 03/02/2019
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    weak var delegate: WeatherViewControllerDelegate?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        AppConfigurator.configure(application, with: launchOptions)
        window = UIWindow(frame: UIScreen.main.bounds)

        let tabBarController = UITabBarController()

        let settingsViewController = SettingsViewController(dependencies: Services)
        settingsViewController.tabBarItem = UITabBarItem(title: "SETTINGS",
                                                         image: UIImage(named: "icons8-settings"),
                                                         tag: 0)

        let weatherViewController = WeatherViewController(dependencies: Services)
        self.delegate = weatherViewController
        weatherViewController.tabBarItem = UITabBarItem(title: "WEATHER", image: UIImage(named: "weather"), tag: 1)

        let locationsViewController = LocationsViewController(dependencies: Services)
        locationsViewController.tabBarItem = UITabBarItem(title: "LOCATIONS", image: UIImage(named: "location"), tag: 2)

        tabBarController.viewControllers = [settingsViewController, weatherViewController, locationsViewController]
        tabBarController.selectedIndex = 1

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let weatherViewController = delegate {
            weatherViewController.applicationWillEnterForeground()
        }
    }
}
