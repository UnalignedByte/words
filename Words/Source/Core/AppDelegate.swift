//
//  AppDelegate.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        setupAnalytics()
        printDebugInfo()

        return true
    }


    fileprivate func setupAnalytics()
    {
        #if !DEBUG
            Fabric.with([Crashlytics.self])
        #endif
    }


    fileprivate func printDebugInfo()
    {
        #if DEBUG
            let libraryUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            print("Library Path: \(libraryUrl.path)")
        #endif
    }
}
