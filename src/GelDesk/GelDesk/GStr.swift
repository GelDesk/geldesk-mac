//
//  GStr.swift
//  GelDesk
//
//  Created by Wayne on 3/3/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

// MARK: String Utilities
/**
String Utilities

*This class is an extension target for common string functions. An alternative
to publicly extending `String`, this class is extended with `static` functions
that accept a `String` as their first argument.*

See also: `Gpath`
*/
public final class GStr { }

/**
Character Resources
 
See also: `GStr`
*/
public final class GChar { }

// MARK: Characters
public extension GChar {
    
    public static let sQuote: Character = "'"
    public static let dQuote: Character = "\""
    public static let space: Character = " "
    
}

// MARK: Strings
public extension GStr {
    
    public static let sQuote = "'"
    public static let dQuote = "\""
    public static let space = " "
    
    private static let vowels = ["a", "e", "i", "o", "u"]
    
    private static let consonants = ["b", "c", "d", "f", "g", "h", "j", "k",
        "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
    
}

// MARK: Core
public extension GStr {
    
    /// Returns the character in `src` at the given index, `i`.
    public static func charAt(src: String, _ i: Int) -> Character {
        let index = src.startIndex.advancedBy(i)
        return src[index]
    }
    
    /// Returns `true` if the given `src` string contains `s`.
    public static func contains(src: String, _ s: String) -> Bool {
        return src.rangeOfString(s) != nil
    }
    
    public static func data(src: String) -> NSData? {
        return src.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    public static func getMatches(
        src: String,
        _ regex: String,
        _ options: NSRegularExpressionOptions = [],
        _ matching: NSMatchingOptions = [])
        -> [NSTextCheckingResult]
    {
        let exp = try? NSRegularExpression(pattern: regex, options: options)
        let matches = exp?.matchesInString(
            src,
            options: matching,
            range: NSMakeRange(0, src.characters.count))
        return matches! as [NSTextCheckingResult]
    }
    
    public static func indexOf(src: String, _ target: String) -> Int {
        if let range = src.rangeOfString(target) {
            return src.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    public static func indexOf(
        src: String,
        _ target: String,
        _ startIndex: Int)
        -> Int
    {
        let startRange = src.startIndex.advancedBy(startIndex)
        
        if let range = src.rangeOfString(
            target,
            options: NSStringCompareOptions.LiteralSearch,
            range: Range<String.Index>(
                start: startRange,
                end: src.endIndex)) {
                    return src.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    /// Returns true if the `src` string matches the given `regex`.
    public static func isMatch(
        src: String,
        _ regex: String,
        _ options: NSRegularExpressionOptions = [],
        _ matching: NSMatchingOptions = [])
        -> Bool
    {
        let exp = try? NSRegularExpression(pattern: regex, options: options)
        let matchCount = exp?.numberOfMatchesInString(
            src,
            options: matching,
            range: NSMakeRange(0, src.characters.count))
        return matchCount > 0
    }
    
    public static func lastIndexOf(src: String, _ target: String) -> Int {
        var index = -1
        var stepIndex = indexOf(src, target)
        let targetLen = target.characters.count
        let srcLen = src.characters.count
        while stepIndex > -1 {
            index = stepIndex
            if stepIndex + targetLen < srcLen {
                stepIndex = indexOf(src, target, stepIndex + targetLen)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    public static func length(src: String) -> Int {
        return src.characters.count
    }
    
    public static func pluralize(src: String, _ count: Int) -> String {
        if count == 1 {
            return src
        } else {
            let srcLen = src.characters.count
            let lastChar = substring(src, srcLen - 1, 1)
            let secondToLastChar = substring(src, srcLen - 2, 1)
            var prefix = "", suffix = ""
            
            if lastChar.lowercaseString == "y"
                && vowels.filter({x in x == secondToLastChar}).count == 0
            {
                prefix = range(src, 0...srcLen - 1)
                suffix = "ies"
            } else if lastChar.lowercaseString == "s"
                || (
                    lastChar.lowercaseString == "o"
                        && consonants.filter({
                            x in x == secondToLastChar
                        }).count > 0
                ) {
                    prefix = range(src, 0...srcLen)
                    suffix = "es"
            } else {
                prefix = range(src, 0...srcLen)
                suffix = "s"
            }
            return prefix + (lastChar != lastChar.uppercaseString ?
                suffix : suffix.uppercaseString)
        }
    }
    
    public static func dQuotes(src: String) -> String {
        return GStr.dQuote + src + GStr.dQuote
    }
    
    public static func sQuotes(src: String) -> String {
        return GStr.sQuote + src + GStr.sQuote
    }
    
    public static func range(src: String, _ r: Range<Int>) -> String {
        let startIndex = src.startIndex.advancedBy(r.startIndex)
        let endIndex = src.startIndex.advancedBy(r.endIndex - 1)
        return src[Range(start: startIndex, end: endIndex)]
    }
    
    public static func replace(
        src: String,
        _ target: String,
        _ withString: String)
        -> String
    {
        return src.stringByReplacingOccurrencesOfString(target,
            withString: withString,
            options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    public static func substring(src: String, _ startIndex: Int) -> String {
        return substring(src, startIndex, src.characters.count - startIndex)
    }
    
    public static func substring(
        src: String,
        _ startIndex: Int,
        _ length: Int)
        -> String
    {
        let start = src.startIndex.advancedBy(startIndex)
        let end = src.startIndex.advancedBy(startIndex + length)
        return src.substringWithRange(Range(start..<end))
    }
    
    public static func substring(
        src: String,
        _ start: String.Index,
        _ length: Int)
        -> String
    {
        let end = start.advancedBy(length)
        return src.substringWithRange(Range(start: start, end: end))
    }
    
    public static func substring(
        src: String,
        _ startIndex: Int,
        _ end: String.Index)
        -> String
    {
        let start = src.startIndex.advancedBy(startIndex)
        return src.substringWithRange(
            Range(start: start, end: end))
    }
    
    public static func trim(src: String) -> String {
        return src.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
    }
}

// MARK: CLI
public extension GStr {
    
    /// Returns an array of strings with the command-part in the first element
    /// followed (optionaly) by one element per argument.
    public static func splitCommandAndArguments(
        cmdLine: String,
        removeQuotesFromCommandPart: Bool = true)
        -> [String]
    {
        let parts = splitCommandFromArguments(
            cmdLine,
            removeQuotesFromCommandPart: removeQuotesFromCommandPart)
        if parts.count < 2 {
            return parts
        }
        let argSrc = parts[1]
        // TODO: Find a better way to parse a string of command line arguments
        // instead of just splitting them up by space. Some of them could be
        // quoted...which we can deal with, but more importantly - are there
        // any other rules to splitting Unix command-line args? There has got
        // to be a nice little Obj-C or C function that we can use here.
        var args = argSrc.componentsSeparatedByString(" ")
        args.insert(parts[0], atIndex: 0)
        return args
        // TODO: Maybe implement removeQuotesFromArguments if the resulting
        // array causes a problem in NSTask.arguments.
    }
    
    // Returns an array of strings where the first element is the command and
    // the (optional) second element is the string of arguments.
    public static func splitCommandFromArguments(
        cmdLine: String,
        removeQuotesFromCommandPart: Bool = true)
        -> [String]
    {
        let line = trim(cmdLine)
        let count = line.characters.count
        if count == 0 {
            return [line]
        }
        var inSingleQuote = false
        var inDoubleQuote = false
        var commandPart: String = ""
        var hasQuotes = false
        var i = 0
        for ch in line.characters {
            if ch == GChar.dQuote && !inSingleQuote {
                inDoubleQuote = !inDoubleQuote
                hasQuotes = true
            } else if ch == GChar.sQuote && !inDoubleQuote {
                inSingleQuote = !inSingleQuote
                hasQuotes = true
            } else if !inSingleQuote
                && !inDoubleQuote
                && ch == GChar.space
            {
                if hasQuotes && removeQuotesFromCommandPart {
                    commandPart = substring(line, 1, i - 2)
                } else {
                    commandPart = substring(line, 0, i)
                }
                let args = substring(line, i + 1)
                return [commandPart, args]
            }
            i += 1
        }
        return [hasQuotes ? substring(line, 1, i - 2) : line]
    }
}

// MARK: JSON
public extension GStr {
    /// Returns the JSON object from `src` decoded by `NSJSONSerialization`.
    public static func decodeJSON(
        src: String,
        options: NSJSONReadingOptions = .AllowFragments)
        throws -> AnyObject
    {
        let srcData = data(src)!
        let decodedObj = try NSJSONSerialization.JSONObjectWithData(
            srcData,
            options: options)
        return decodedObj
    }
}

// MARK: Debugging
public extension GStr {
    /// Returns `src` if it is NOT `nil`, else the alternate value.
    /// (This is a workaround for using the `??` operator in a string-
    /// interpolation with the `print` command causes build times to 
    /// increase drastically.)
    public static func ifNil(src: String?, alternate: String = "") -> String {
        return src ?? alternate
    }
}
