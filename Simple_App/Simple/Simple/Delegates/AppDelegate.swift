//
//  AppDelegate.swift
//  Simple
//
//  Created by Rastislav Smolen on 06/08/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
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
