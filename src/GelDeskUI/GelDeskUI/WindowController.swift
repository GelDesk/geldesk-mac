//
//  WindowController.swift
//  GelDesk
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation
import Cocoa
import GelDesk
import GelDeskCocoa

public class WindowController : ComponentObject {
    
    public override init(name: String = "Window") {
        super.init(name: name)
    }
    
    private let title = "GelDesk Window"
    
    let window = NSWindow(
        contentRect: NSMakeRect(0, 0, NSScreen.mainScreen()!.frame.width/2, NSScreen.mainScreen()!.frame.height/2),
        styleMask: NSTitledWindowMask|NSResizableWindowMask|NSMiniaturizableWindowMask|NSClosableWindowMask,
        backing: NSBackingStoreType.Buffered,
        `defer`: false)
    
    public func createWindow(){
        window.title = title
        window.opaque = false
        window.center()
        window.movableByWindowBackground = true
        window.backgroundColor = NSColor(calibratedHue: 0, saturation: 1.0, brightness: 0, alpha: 0.7)
        window.makeKeyAndOrderFront(nil)
        window.makeMainWindow()
    }
    
}
