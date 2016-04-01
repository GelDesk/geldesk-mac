//
//  GPath.swift
//  GelDesk
//
//  Created by Wayne on 3/20/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Cocoa
import Foundation

// MARK: Path Utilities
/**
Path Utilities

*This class is an extension target for common string-based path functions.*
*/
public final class GPath { }

// MARK: Core
public extension GPath {
    
    public static let separator = "/"
    public static let relativeParentPrefix = "../"
    public static let relativePrefix = "./"
    public static let relativeParentSuffix = "/.."
    
    public static func absolute(path: String) -> String {
        if isAbsolute(path) {
            return normalize(path)
        }
        let curDir = NSFileManager.defaultManager().currentDirectoryPath
        let joinedPath = curDir + separator + path
        return normalize(joinedPath)
    }
    
    public static func isAbsolute(path: String) -> Bool {
        return path.hasPrefix(separator)
    }
    
    public static func isRelative(path: String) -> Bool {
        return path.hasPrefix(relativePrefix)
            || path.hasPrefix(relativeParentPrefix)
    }
    
    public static func normalize(path: String) -> String {
        return NSString(string: path).stringByStandardizingPath
    }
    /// Returns the parent path using `normalize`.
    public static func normalizeToParent(path: String) -> String {
        let parentPath = path + relativeParentSuffix
        return normalize(parentPath)
    }
}

// MARK: JSON
public extension GPath {
    
    public static func decodeJSON(
        file: String,
        options: NSJSONReadingOptions = .AllowFragments)
        throws -> AnyObject
    {
        let fileData = NSData(contentsOfFile: file)!
        let decodedObj = try NSJSONSerialization.JSONObjectWithData(
            fileData,
            options: options)
        return decodedObj
    }
    
}
