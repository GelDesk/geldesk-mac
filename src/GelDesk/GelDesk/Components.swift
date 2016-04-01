//
//  Components.swift
//  GelDesk
//
//  Created by Wayne on 2/20/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public protocol ComponentType {
    var name: String { get }
    var components: ComponentCollection? { get }
}

public class ComponentObject : ComponentType {

    public init(name: String) {
        self.name = name
        self.components = nil
    }

    public let name : String
    public var components : ComponentCollection?
}

public struct ComponentCollection : CollectionType {
    
    public init() { }
    
    public enum Error: ErrorType {
        case ElementWithNameExists
    }
    
    var byIndex = [ComponentType]()
    var byKey = [String:ComponentType]()
    
    public mutating func add(component:ComponentType) throws {
        if byKey[component.name] != nil {
            throw Error.ElementWithNameExists
        }
        byKey[component.name] = component
        byIndex.append(component)
    }
    
    public var count: Int {
        return byIndex.count
    }
    
    public var endIndex: Int { return byIndex.endIndex }
    
    public func generate() -> IndexingGenerator<[ComponentType]> {
        return byIndex.generate()
    }
    
    public func getByPath(path: String) -> ComponentType? {
        // TODO: Split the path and descend into components.
        return self[path]
    }
    
    public mutating func remove(component:ComponentType) -> Bool {
        return self.remove(component.name)
    }
    
    public mutating func remove(name:String) -> Bool {
        if byKey.removeValueForKey(name) == nil {
            return false
        }
        let i = byIndex.indexOf { c in c.name == name }
        if i != nil {
            byIndex.removeAtIndex(i!)
        }
        return true
    }
    
    public var startIndex: Int { return byIndex.startIndex }
    
    public subscript(name: String) -> ComponentType? {
        return byKey[name]
    }
    
    public subscript(position: Int) -> ComponentType {
        return byIndex[position]
    }
    
    public subscript(subRange: Range<Int>) -> ArraySlice<ComponentType> {
        return byIndex[subRange]
    }
}
