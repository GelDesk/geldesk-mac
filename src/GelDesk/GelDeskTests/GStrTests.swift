//
//  StringTests.swift
//  GelDesk
//
//  Created by Wayne on 3/21/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import XCTest
@testable import GelDesk
import Foundation

class GStrTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCharAt() {
        let src = "Hello -The characters."
        let e: Character = "e"
        let eIdx = 1
        let T: Character = "T"
        let TIdx = 7
        
        let eRes = GStr.charAt(src, eIdx)
        let TRes = GStr.charAt(src, TIdx)
        
        XCTAssertEqual(eRes, e,
            "Expected character \(e) at index \(eIdx), not \(eRes).")
        XCTAssertEqual(TRes, T,
            "Expected character \(T) at index \(TIdx), not \(TRes).")
    }
    
    func testContains() {
        let src = "Container buffalo container buffalo container buffalo."
        let Container = "Container"
        let container = "container"
        let buffalo = "buffalo"
        
        let rC = GStr.contains(src, Container)
        let rc = GStr.contains(src, container)
        let rb = GStr.contains(src, buffalo)
        
        XCTAssert(rC, "Expected src to contain '\(Container)'.")
        XCTAssert(rc, "Expected src to contain '\(container)'.")
        XCTAssert(rb, "Expected src to contain '\(buffalo)'.")
    }
    
    func testGetMatches() {
        let src = "This is a test. Testing 1, 2, 3."
        let matches = GStr.getMatches(src, "[0-9],",
            .AllowCommentsAndWhitespace)
        
        XCTAssertEqual(matches.count, 2, "Expected 2 matches.")
        XCTAssertEqual(GStr.substring(src, matches[0].range.location,
            matches[0].range.length), "1,", "Expected match: 1,")
        XCTAssertEqual(GStr.substring(src, matches[1].range.location,
            matches[1].range.length), "2,", "Expected match: 2,")
    }
    
    func testIndexOf() {
        let src = "This is a test. Testing 1, 2, 3."
        let i1 = GStr.indexOf(src, "1")
        let i2 = GStr.indexOf(src, "2", i1)
        
        XCTAssert(i1 == 24, "Expected '1' at index 24.")
        XCTAssert(i2 == 27, "Expected '2' at index 27.")
    }
    
    func testIsMatch() {
        let src = "THIS!"
        let r = GStr.isMatch(src, "THIS!")
        let r2 = GStr.isMatch(src, "NOT!")
        XCTAssert(r, "Expected a match.")
        XCTAssert(r2 == false, "Did not expect a match.")
    }
    
    func testLastIndexOf() {
        let src = "This is a test. Testing 1, 2, 3."
        let i = GStr.lastIndexOf(src, "s")
        
        XCTAssert(i == 18, "Expected last 's' at index 18, not \(i).")
    }
    
    func testSplitCommandAndArguments() {
        let cmd = "/the/command"
        let args = "-the args etc"
        let cmdLine = cmd + " " + args
        
        let r1 = GStr.splitCommandAndArguments(cmd)
        XCTAssert(r1.count == 1, "Expected a count of 1, not \(r1.count).")
        XCTAssertEqual(r1[0], cmd, "Expected '\(cmd)', not '\(r1[0])'.")
        
        let r2 = GStr.splitCommandAndArguments(cmdLine)
        XCTAssert(r2.count == 4, "Expected a count of 2, not \(r2.count).")
        XCTAssertEqual(r2[0], cmd, "Expected '\(cmd)', not '\(r2[0])'.")
        XCTAssertEqual(r2[1], "-the", "Expected '-the', not '\(r2[1])'.")
        XCTAssertEqual(r2[2], "args", "Expected 'args', not '\(r2[2])'.")
        XCTAssertEqual(r2[3], "etc", "Expected 'etc', not '\(r2[3])'.")
        
        
    }
    
    func testSplitCommandFromArguments() {
        let cmd = "/the/command"
        let args = "-the args etc"
        let cmdLine = cmd + " " + args
        
        let r1 = GStr.splitCommandFromArguments(cmd)
        XCTAssert(r1.count == 1, "Expected a count of 1, not \(r1.count).")
        XCTAssertEqual(r1[0], cmd, "Expected '\(cmd)', not '\(r1[0])'.")
        
        let r2 = GStr.splitCommandFromArguments(cmdLine)
        XCTAssert(r2.count == 2, "Expected a count of 2, not \(r2.count).")
        XCTAssertEqual(r2[0], cmd, "Expected '\(cmd)', not '\(r2[0])'.")
        XCTAssertEqual(r2[1], args, "Expected '\(args)', not '\(r2[1])'.")
        
        let r3 = GStr.splitCommandFromArguments(
            GStr.dQuotes(cmd),
            removeQuotesFromCommandPart: true)
        XCTAssert(r3.count == 1, "Expected a count of 1, not \(r3.count).")
        XCTAssertEqual(r3[0], cmd, "Expected '\(cmd)', not '\(r3[0])'.")
        
        let r4 = GStr.splitCommandFromArguments(
            GStr.dQuotes(cmd) + " " + args,
            removeQuotesFromCommandPart: true)
        XCTAssert(r4.count == 2, "Expected a count of 2, not \(r4.count).")
        XCTAssertEqual(r4[0], cmd, "Expected '\(cmd)', not '\(r4[0])'.")
        XCTAssertEqual(r4[1], args, "Expected '\(args)', not '\(r4[1])'.")
    }
    
    func testTrim() {
        let expect = "Needs to be trimmed!"
        let src = " " + expect + "    "
        let r = GStr.trim(src)
        XCTAssertEqual(r, expect, "Expected a trimmed string, not: '\(r)'.")
    }
}
