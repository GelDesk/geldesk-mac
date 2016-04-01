//
//  RPCMessageTests.swift
//  GelDesk
//
//  Created by Wayne on 3/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import XCTest
@testable import GelDesk

class RPCMessageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEncodeNotification() {
        let input = "[\"path\",[\"args\"],-1]"
        let msg = RPCMessage(
            path: "path",
            arguments: ["args"],
            requestId: -1,
            error: nil)
        let json = RPCMessage.encode(msg)
//        print(json)
        XCTAssertEqual(json, input, "Expected `json` to equal `input`.")
    }
    
    func testEncodeNotificationError() {
        let nsErr = RPCErrorCode.toNSError(-32599)
        let input = "[\"path\",[],-1]"
        let msg = RPCMessage(
            path: "path",
            arguments: nil,
            requestId: -1,
            error: nsErr)
        let json = RPCMessage.encode(msg)
        print(json)
//        XCTAssertEqual(json, input, "Expected `json` to equal `input`.")
    }
    
    func testEncodeNotificationError2() {
        let nsErr: NSError!
        do {
            try GStr.decodeJSON("rubbish")
            nsErr = RPCErrorCode.toNSError(0)
        } catch let caughtErr as NSError {
            nsErr = caughtErr
        }
        let input = "[\"path\",[],-1]"
        let msg = RPCMessage(
            path: "path",
            arguments: nil,
            requestId: -1,
            error: nsErr)
        let json = RPCMessage.encode(msg)
        print(json)
        //        XCTAssertEqual(json, input, "Expected `json` to equal `input`.")
    }
    
    func testEncodeNotificationNilArguments() {
        let input = "[\"path\",[],-1]"
        let msg = RPCMessage(
            path: "path",
            arguments: nil,
            requestId: -1,
            error: nil)
        let json = RPCMessage.encode(msg)
//        print(json)
        XCTAssertEqual(json, input, "Expected `json` to equal `input`.")
    }
    
    func testEncodeNotificationNoArguments() {
        let input = "[\"path\",[],-1]"
        let msg = RPCMessage(
            path: "path",
            arguments: [],
            requestId: -1,
            error: nil)
        let json = RPCMessage.encode(msg)
        //        print(json)
        XCTAssertEqual(json, input, "Expected `json` to equal `input`.")
    }
    
    func testEncodeRequest() {
        let input = "[\"path\",[\"args\"],1]"
        let msg = try! RPCMessage.decode(input)
        let json = RPCMessage.encode(msg)
        //        print(json)
        XCTAssertEqual(json, input, "Expected `json` to equal `input`.")
    }
    
    func testEncodeResponse() {
        let input = "[[null,\"args\"],1]"
        let msg = try! RPCMessage.decode(input)
        let json = RPCMessage.encode(msg)
        //        print(json)
        XCTAssertEqual(json, input, "Expected `json` to equal `input`.")
    }
    
    func testDecodeInvalidJson() {
        var err: NSError? = nil
        do {
            let msg = try RPCMessage.decode("should be JSON but is not JSON")
            XCTAssert(false, "This line should not be reached. msg: \(msg)")
        } catch let caughtErr as NSError {
            err = caughtErr
        }
        XCTAssert(err != nil, "Expected non-nil error.")
        print(err!)
    }
    
    func testDecodeRequest() {
        let msg = try! RPCMessage.decode("[\"path\", [\"args\"], 1]")
        
        XCTAssert(msg.path == "path", "Expected path of 'path'.")
        
        XCTAssert(msg.arguments != nil, "Expected arguments.")
        XCTAssert(msg.arguments!.count == 1, "Expected argument count of 1.")
        
        let arg1 = msg.arguments![0] as? String
        XCTAssert(arg1 != nil, "arg1 should be non-nil.")
        XCTAssert(arg1 == "args", "arg1 should be 'args'.")
        
        XCTAssert(msg.requestId == 1, "requestId should be 1.")
        
        XCTAssert(msg.hasError == false, "hasError should be false.")
        XCTAssert(msg.isRequest, "isRequest should be true.")
        XCTAssert(msg.isResponse == false, "isResponse should be false.")
        XCTAssert(msg.isNotification == false, "isNotification should be false.")
    }
    
    func testDecodeResponse() {
        let msg = try! RPCMessage.decode("[[null, \"args\"], 1]")
        
        XCTAssert(msg.path == nil, "Expected nil 'path'.")
        
        XCTAssert(msg.arguments != nil, "Expected arguments.")
        XCTAssert(msg.arguments!.count == 1, "Expected argument count of 1.")
    }
    
    func testDecodeResponseErrorCode() {
        let msg = try! RPCMessage.decode("[[777], 1]")
        
        XCTAssert(msg.path == nil, "msg.path should be nil.")
        
        XCTAssert(msg.arguments != nil, "Expected arguments.")
        XCTAssert(msg.arguments!.count == 0, "Expected argument count of 0.")
        
        XCTAssert(msg.requestId == 1, "Expected requestId of 1.")
        
        XCTAssert(msg.error != nil, "msg.error should NOT be nil.")
        let err2 = msg.error!
        XCTAssert(err2.code == 777, "err2.code should be 777.")
        print(err2)
    }
}
