//
//  AppDelegate.swift
//  HDH
//
//  Created by Matt Lu and Ayman Rahadian on 11/15/18.
//  Copyright © 2018 pronto. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate  {
    
    let APPLICATION_ID = "76C846D1-971C-4053-FF29-55BD3AD66100"
    let API_KEY = "E2B53A47-2AD7-A244-FF64-F05A4B460600"
    let SERVER_URL = "https://api.backendless.com"
    let backendless = Backendless.sharedInstance()!
    var navigationController: UINavigationController?
    var email = ""
   
    var window: UIWindow?

    public class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "928882721015-tl8gd45fp4s5djogi8afjlr1k8tvq9e8.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()
        
        // Backendless
        backendless.hostURL = SERVER_URL
        backendless.initApp(APPLICATION_ID, apiKey: API_KEY)
        
        
        //Initial Tab Bar
        if let tabBarController = self.window!.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }

        //Tab Bar Appearance
        UITabBar.appearance().barTintColor = UIColor(red: 15/255, green: 43/255, blue: 91/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBar.appearance().tintColor = UIColor.white
        
        //Nav Bar Appearance
        UINavigationBar.appearance().barTintColor = UIColor(red: 15/255, green: 43/255, blue: 91/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }

    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var options: [String: AnyObject] = [UIApplication.OpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplication.OpenURLOptionsKey.annotation.rawValue: annotation!]
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            //let photo = user.profile.imageURL(withDimension: <#T##UInt#>)
            if (email?.contains("mwebster@hotchkiss.org"))! || (email?.contains("mlu@hotchkiss.org"))!{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = ViewController()
                let feedback = storyboard.instantiateViewController(withIdentifier: "Feedback") as! FeedbackViewController
                let login = storyboard.instantiateViewController(withIdentifier: "Login") as! FeedbackLoginViewController
                navigationController = UINavigationController(rootViewController: mainVC)
                
                let tabBar = window?.rootViewController as! UITabBarController
                tabBar.viewControllers![3] = feedback
                tabBar.viewControllers![3].tabBarItem.title = "Settings"
                tabBar.viewControllers![3].tabBarItem.image = UIImage(named: "Settings Icon")
 
            }else{
                signIn.signOut()
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    /*
    func loadDataFromTable() {
        let backendless = Backendless.sharedInstance()!
        let readStore = backendless.data.of(Email.ofClass())
        Types.tryblock({() -> Void in
            let emailArr = readStore?.find() as! [Email]
            print(emailArr)
            
        },
                       catchblock: { (exception) -> Void in
                        print("Server reported an error: \(String(describing: exception))")
        })
        print("Load done!")
    }
    */
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HDH")
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

