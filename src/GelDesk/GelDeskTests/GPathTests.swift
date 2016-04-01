//
//  PathTests.swift
//  GelDesk
//
//  Created by Wayne on 3/20/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import XCTest
@testable import GelDesk
import Foundation

class GPathTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAbsolute() {
        let nonAbsPath = "geldesk.json"
        let curDir = NSFileManager.defaultManager().currentDirectoryPath
        let expectPath = curDir + "/" + nonAbsPath
        let absPath = GPath.absolute(nonAbsPath)
        XCTAssertEqual(expectPath, absPath,
            "Expected path: \(expectPath) but got: \(absPath)")
    }
    
    func testIsAbsolute() {
        let absPath = "/Users/wayne/code/geldesk-mac"
        let nonAbsPath = "geldesk.json"
        var b = GPath.isAbsolute(absPath)
        XCTAssert(b, "Expected true for: \(absPath)")
        b = GPath.isAbsolute(nonAbsPath)
        XCTAssert(b == false, "Expected false for: \(nonAbsPath)")
    }
    
    func testNormalize() {
        let absPath = "/Users/wayne/code/geldesk-mac"
        let appendedPath = absPath + "/../../files"
        let expectPath = "/Users/wayne/files"
        var resultPath = GPath.normalize(appendedPath)
        XCTAssertEqual(resultPath, expectPath,
            "Expected path: \(expectPath) but got: \(resultPath)")
    }
}