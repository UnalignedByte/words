//
//  AppDelegate.swift
//  Words
//
//  Created by Rafal Grodzinski on 25/02/16.
//  Copyright © 2016 UnalignedByte. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let libraryUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        print("Library Path: \(libraryUrl.path)")

        return true
    }
}
