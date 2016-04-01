//
//  ConfigurationTests.swift
//  GelDesk
//
//  Created by Wayne on 3/20/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import XCTest
@testable import GelDesk
import Foundation

class ConfigurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChildProcessConfigFromCommand() {
        let cmd = "/my/node"
        let args = "./command.js"
        let cmdLine = cmd + " " + args
        let wd = "/tmp"
        
        let cpc = ChildProcessConfig.fromCommand(cmdLine, workingDirectory: wd)
        
        XCTAssert(cpc.command != nil, "Expected .command.")
        XCTAssert(cpc.arguments != nil, "Expected .arguments.")
        XCTAssert(cpc.workingDirectory != nil, "Expected .workingDirectory.")
        
        XCTAssertEqual(cmd, cpc.command,
            "Expected .command to be '\(cmd)' not '\(cpc.command!)'.")
//        XCTAssertEqual(args, cpc.arguments,
//            "Expected .arguments to be '\(args)' not '\(cpc.arguments!)'.")
        XCTAssertEqual(wd, cpc.workingDirectory,
            "Expected .workingDirectory to be '\(wd)' not" +
            " '\(cpc.workingDirectory!)'.")
        
    }
}
