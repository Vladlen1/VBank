//
//  AppDelegate.swift
//  VBank
//
//  Created by Vlad Birukov on 05.11.2017.
//  Copyright © 2017 Vlad Birukov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let logoutrepo = LoginRepo()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.window?.rootViewController = BaseNavigationController.init(rootViewController: loginVC)  
        self.window?.makeKeyAndVisible()
        
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = ColorUtility.statusBarColor()
        }
        UIApplication.shared.statusBarStyle = .lightContent

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
//        self.logoutrepo.logout()
//
//        window = UIWindow(frame: UIScreen.main.bounds)
//
//
//        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
//        self.window?.rootViewController = BaseNavigationController.init(rootViewController: loginVC)
//        self.window?.makeKeyAndVisible()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        self.logoutrepo.logout()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

