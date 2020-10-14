//
//  AppDelegate.swift
//  VtronixApp
//
//  Created by samstag on 28.04.2020.
//  Copyright © 2020 Vtronix. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        // Create tabbar
        
        let categoryListVC = CategoryListViewController.init(category: DataManager.shared.rootCategory)
        let categoryListNavVC = UINavigationController.init(rootViewController: categoryListVC)

        let productSpecsVC = ProductSpecsViewController.init()
        let productSpecsNavVC = UINavigationController.init(rootViewController: productSpecsVC)

        let contactUsVC = ContactUsViewController.init()
        let contactUsNavVC = UINavigationController.init(rootViewController: contactUsVC)
        
        let tabBarVC = UITabBarController.init()
        tabBarVC.tabBar.isOpaque = true
        tabBarVC.tabBar.tintColor = UIColor.vtronixBlue
        tabBarVC.viewControllers = [categoryListNavVC, productSpecsNavVC, contactUsNavVC]
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarVC
        self.window?.makeKeyAndVisible()
        
        // ---
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.appFontRegular(ofSize: 18.0)], for: .normal)
        
        return true
    }

}
