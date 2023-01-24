//
//  AppDelegate.swift
//  Simple
//
//  Created by Rastislav Smolen on 06/08/2022.
//

import UIKit
import CoreData
import NotificationCenter

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    
    var appCoordinator : AppCoordinator?
    
    lazy var persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "Simple")
         container.loadPersistentStores { description, error in
             if let error = error {
                 fatalError("Unable to load persistent stores: \(error)")
             }
         }
         return container
     }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    if granted {
                        print("User gave permissions for local notifications")
                    }
                }
        setupCoordinator()
        return true
    }
    
}
extension AppDelegate {
    
    func setupCoordinator() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationCon = UINavigationController.init()
        
        navigationCon.navigationBar.isTranslucent = true
        appCoordinator = AppCoordinator(navigationController: navigationCon)
        
        appCoordinator?.start()
        
        window?.rootViewController = navigationCon
        
        window?.makeKeyAndVisible()
        
    }
}
