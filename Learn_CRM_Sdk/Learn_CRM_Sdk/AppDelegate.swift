//
//  AppDelegate.swift
//  Learn_CRM_Sdk
//
//  Created by ZU-IOS on 04/03/20.
//  Copyright © 2020 ZU-IOS. All rights reserved.
//

import UIKit
import CoreData
import ZCRMiOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    var loginHandler : ZCRMLoginHandler?
    private var appConfigurationDict : Dictionary< String, Any > = Dictionary< String, Any >()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            do
            {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.makeKeyAndVisible()
                
                
                if let window = self.window
                {
                    try ZCRMSDKClient.shared.initSDK(window: window)
                    ZCRMSDKClient.shared.turnLoggerOn (minLogLevel : .debug )
    //                ZCRMSDKClient.shared.isDBCacheEnabled = false
                }
                else
                {
                    print("Window is nil")
                }
                
                let viewController = ViewController()
                
                let navController = UINavigationController( rootViewController : viewController )
                self.window?.rootViewController = navController
                self.window?.makeKeyAndVisible()
//                let viewController = ListViewController()
                //let navController = UINavigationController( rootViewController : viewController )
                //self.window?.rootViewController = navController
                //self.window?.makeKeyAndVisible()
            }
            catch
            {
                print("unable to init ZCRMiOS SDK : \(error)")
            }
            
            return true
        }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        ZCRMSDKClient.shared.handle(url: url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceapp = options[ UIApplication.OpenURLOptionsKey.sourceApplication ]
        ZCRMSDKClient.shared.handle( url : url, sourceApplication : sourceapp as? String, annotation: "" )
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Learn_CRM_Sdk")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

