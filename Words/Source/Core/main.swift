//
//  main.swift
//  Words
//
//  Created by Rafal Grodzinski on 14/03/2017.
//  Copyright © 2017 UnalignedByte. All rights reserved.
//

import UIKit


let isRunningTests = NSClassFromString("XCTestCase") != nil

var appDelegateClassString: String!
if isRunningTests {
    appDelegateClassString = NSStringFromClass(UnitTestsAppDelegate.self)
} else {
    appDelegateClassString = NSStringFromClass(AppDelegate.self)
}

_ = withUnsafeMutablePointer(to: &CommandLine.unsafeArgv.pointee!) { argv in
    UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClassString)
}
