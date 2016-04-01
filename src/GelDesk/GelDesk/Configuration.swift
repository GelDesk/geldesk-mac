//
//  Configuration.swift
//  GelDesk
//
//  Created by Wayne on 3/20/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

/// Contains data captured from a config file or command arguments.
public struct AppConfig {
    /// Full path of the file that the configuration originated from, if any.
    public var file: String?
    /// Configuration for each process that should be launched.
    public var childProcesses: [ChildProcessConfig]?
}

/// Configuration for a child process to be launched.
public struct ChildProcessConfig {
    /// Arguments for the `command`.
    public var arguments: [String]?
    /// The launch path of the command to execute.
    public var command: String?
    /// Name of the child process, if any.
    public var name: String?
    /// Full path of the directory to execute the `command` in.
    public var workingDirectory: String?
}

public extension AppConfig {
    
    /// Default file name for a GelDesk config file.
    public static let defaultFileName = "geldesk.json"
    
    /// Returns true if any configuration data exists.
    public var exists: Bool {
        return file != nil
            || childProcesses?.count > 0
    }
    
    /// Returns a new `AppConfig` from the file specified in 
    /// `Process.arguments`, the arguments themselves or the
    /// `defaultFileName` if there are no arguments.
    public static func readCommandLineArgs() -> AppConfig {
        let count = Process.arguments.count
        let from = 1
        #if DEBUG
            // Deduct the last 2 arguments that Xcode adds while debugging.
            let to = count - 2
        #else
            let to = count
        #endif
        let trueCount = to - from
        if trueCount == 0 {
            return readJSON(AppConfig.defaultFileName)
        } else if trueCount == 1 {
            return readJSON(Process.arguments[from])
        } //else {
            // TODO: Read all args to construct an instance of AppConfig.
        //}
        return AppConfig()
    }
    
    /// Returns a new `AppConfig` created from reading the given JSON file path.
    public static func readJSON(file: String) -> AppConfig {
        let afile = GPath.absolute(file)
        print("AppConfig.readJSON file '\(afile)'")
        if !NSFileManager.defaultManager().fileExistsAtPath(afile) {
            return AppConfig()
        }
        let data = try! GPath.decodeJSON(afile) as! [String: AnyObject]
        let workingDir = GPath.normalizeToParent(afile)
        return readJSON(
            data,
            fromFile: afile,
            workingDirectory: workingDir)
    }
    
    /// Returns a new `AppConfig` created from the given JSON object data.
    public static func readJSON(
        data: [String: AnyObject],
        fromFile: String? = nil,
        workingDirectory: String? = nil
    ) -> AppConfig {
        var procs = [ChildProcessConfig]()
        if let run = data["run"] as? String {
            let proc = ChildProcessConfig.fromCommand(
                GStr.trim(run),
                workingDirectory: workingDirectory)
            procs.append(proc)
        }
        return AppConfig(
            file: fromFile,
            childProcesses: procs.count > 0 ? procs : nil
        )
    }
    
}

public extension ChildProcessConfig {
    
    /// Returns a new `ChildProcessConfig` from the given command information.
    public static func fromCommand(
        cmdLine: String,
        workingDirectory: String? = nil
    ) -> ChildProcessConfig {
        var config = ChildProcessConfig()
        let cmdParts = GStr.splitCommandAndArguments(cmdLine)
        let count = cmdParts.count
        if count > 0 {
            config.command = cmdParts[0]
            config.workingDirectory = workingDirectory
            config.resolveCommandBash()
        }
        if count > 1 {
            config.arguments = Array(cmdParts.dropFirst(1))
        }
        return config
    }
    
    /// A hack to try and find the full path to the given command using bash.
    // (Apologies to users of other shells.)
    public mutating func resolveCommandBash() -> Bool {
        guard let cmd = command else {
            return false
        }
        if GPath.isAbsolute(cmd) || GPath.isRelative(cmd) {
            return true
        }
        if cmd.containsString(GPath.separator) {
            return false
        }
        guard let abs = launchTaskReadOutput("/bin/bash", "-l", "-c", "which " + cmd) else {
            return false
        }
        command = abs
        return true
    }
    
}
