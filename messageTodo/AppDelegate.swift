//
//  AppDelegate.swift
//  messageTodo
//
//  Created by Toshiyana on 2021/10/10.
//

import UIKit
import RealmSwift

// Xcode12から@UIApplicationMainから@mainに変更
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!

        let bundleRealmPath = Bundle.main.url(forResource: "default", withExtension: "realm")

        if !FileManager.default.fileExists(atPath: defaultRealmPath.path) {
            do {
                try FileManager.default.copyItem(at: bundleRealmPath!, to: defaultRealmPath)
            } catch let error {
                print("Error reading default.realm. \(error)")
            }
        }

        
//        do {
//            //let realm = try Realm()
//            _ = try Realm()
//        } catch {
//            print("Error initialising new realm, \(error)")
//        }
            
//        print(Realm.Configuration.defaultConfiguration.fileURL)//realmのdataが保存されているファイルまでのpath
        
        setupNotifications(on: application)
        
        return true
    }
}

extension AppDelegate {
    
    func setupNotifications(on application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Failed to request authorization for notification center: \(error.localizedDescription)")
                return
            }
            guard granted else {
                print("Failed to request authorization for notification center: not granted")
                return
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("The notification is about to be presented")
        // iOS14以降では.alertは非推奨。.alert = [.list, .banner]
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        defer { completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else {
            return
        }
        
        let content = response.notification.request.content
        print("Title: \(content.title)")
        print("Body: \(content.body)")
        
        if let userInfo = content.userInfo as? [String: Any],
           let aps = userInfo["aps"] as? [String: Any] {
            print("aps: \(aps)")
        }
    }
}
