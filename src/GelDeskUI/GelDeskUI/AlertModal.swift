//
//  ShowDialog.swift
//  GelDesk
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation
import Cocoa

public class AlertModal {
    
    public static func showOKCancel(message: String, text: String) -> Bool {
        let pop: NSAlert = NSAlert()
        pop.messageText = message
        pop.informativeText = text
        pop.alertStyle = NSAlertStyle.WarningAlertStyle
        pop.addButtonWithTitle("OK")
        pop.addButtonWithTitle("Cancel")
        let res = pop.runModal()
        if res == NSAlertFirstButtonReturn {
            return true
        }
        return false
    }
    
    public static func showOKOnly(message: String, text: String) {
        let pop: NSAlert = NSAlert()
        pop.messageText = message
        pop.informativeText = text
        pop.alertStyle = NSAlertStyle.WarningAlertStyle
        pop.addButtonWithTitle("OK")
        pop.addButtonWithTitle("Cancel")
        pop.runModal()
    }
    
}
