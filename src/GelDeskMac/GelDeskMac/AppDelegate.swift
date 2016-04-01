//
//  AppDelegate.swift
//  GelDeskMac
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Cocoa
import GelDesk
import GelDeskCocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    private let _bootstrapper = Bootstrapper()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        print("AppDelegate.applicationDidFinishLaunching")
        try! _bootstrapper.initializeApp()
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // ...
    }
    
}

