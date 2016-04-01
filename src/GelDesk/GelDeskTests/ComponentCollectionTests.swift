//
//  GelDeskTests.swift
//  GelDeskTests
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import XCTest
@testable import GelDesk

class ComponentCollectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAdd() {
        let count = 3
        let ca: [TestComponent] = [
            TestComponent(name: "c1"),
            TestComponent(name: "c2"),
            TestComponent(name: "c3")
        ]
        var cc = ComponentCollection()
        for item in ca {
            try! cc.add(item)
        }
        XCTAssertEqual(cc.count, count, "Count should be \(count).")
        for var i = 0; i < count; i++ {
            let j = i + 1
            let key = "c\(j)"
            XCTAssert(cc[key] != nil,
                "Value with key '\(key)' does not exist.")
            XCTAssert(cc[key] is TestComponent,
                "Value with key '\(key)' is not a TestComponent.")
            XCTAssert((cc[key] as! TestComponent) === ca[i],
                "Value with key '\(key)' is not the instance that was added.")
            XCTAssert((cc[i] as! TestComponent) === (cc[key] as! TestComponent),
                "Value at position \(i) doesn't match value with key \(key).")
        }
    }
}

public class TestComponent : ComponentObject {
    public override init(name: String) {
        super.init(name: name)
    }
}
