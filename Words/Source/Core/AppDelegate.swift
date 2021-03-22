//
//  AppDelegate.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import UIKit
import Firebase


class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        setupAnalytics()
        printDebugInfo()

        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        if let language = Language.allCases.filter { language in language.code == shortcutItem.type }.first {
            NSLog("Opening %@", language.code)
        }
    }
    
    fileprivate func setupAnalytics()
    {
        FirebaseApp.configure()
    }
    

    fileprivate func printDebugInfo()
    {
        #if DEBUG
            let libraryUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            print("Library Path: \(libraryUrl.path)")
        #endif
    }
}
