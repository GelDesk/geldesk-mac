//
//  GelDesk.swift
//  GelDesk
//
//  Created by Wayne on 3/22/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

/// Adds an observer for the given event name in `NSNotificationCenter`.
func observe(
    observer: AnyObject,
    _ selector: Selector,
    _ name: String?,
    _ object: AnyObject? = nil)
{
    NSNotificationCenter.defaultCenter()
    .addObserver(
        observer,
        selector: selector,
        name: name,
        object: object)
}

/// Returns an observer for the given event name in `NSNotificationCenter`.
func observe(
    name: String?,
    _ object: AnyObject?,
    _ usingBlock: (NSNotification) -> Void)
    -> NSObjectProtocol
{
    let hub = NSNotificationCenter.defaultCenter()
    let observer = hub.addObserverForName(
        name,
        object: object,
        queue: nil,
        usingBlock: usingBlock)
    return observer
}

/// Removes an observer from the default `NSNotificationCenter`.
func removeObserver(
    observer: AnyObject,
    _ name: String? = nil,
    _ object: AnyObject? = nil)
{
    NSNotificationCenter.defaultCenter()
    .removeObserver(
        observer,
        name: name,
        object: object)
}

/**
Launches an NSTask for the given command and returns its output.
 
#### Example:
    let r = launchTaskReadOutput("/bin/bash", "-l", "-c", "which node") ?? ""
    print(">which node: " + r)
*/
func launchTaskReadOutput(command: String, _ arguments: String...) -> String? {
    let task = NSTask()
    task.launchPath = command
    task.arguments = arguments
    
    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = NSString(
        data: data,
        encoding: NSUTF8StringEncoding) as? String
    
    return GStr.trim(output ?? "")
}
