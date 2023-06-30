//
//  AppDelegate.swift
//  KhaltiPay
//
//  Created by Sange Sherpa on 30/06/2023.
//

import UIKit
import Khalti

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let khaltiUrlScheme = "KhaltiPayScheme"
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        Khalti.shared.action(with: url)
        return Khalti.shared.defaultAction()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Khalti.shared.appUrlScheme = khaltiUrlScheme
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: KhaltiPayDelegate {
    
    func onCheckOutSuccess(data: Dictionary<String, Any>) {
        print(data)
    }
    
    func onCheckOutError(action: String, message: String, data: Dictionary<String, Any>?) {
        print(message)
    }
    
}
