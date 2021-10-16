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
        
        do {
            //let realm = try Realm()
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)//realmのdataが保存されているファイルまでのpath
        
        return true
    }

}

