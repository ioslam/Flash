//
//  AppDelegate.swift
//  Flash Chat
//
//  The App Delegate listens for events from the system. 
//  It recieves application level messages like did the app finish launching or did it terminate etc. 
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print( NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true ).last! as String)
        FirebaseApp.configure()
        if let token = helper.getApiToken() {
                   print(token)
                   let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC")
                   window?.rootViewController = tab
               }
        
        return true
    }

    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
     
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

