//
//  IOC.swift
//  GelDesk
//
//  Created by Wayne on 2/19/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public final class IOC {
    
    private static var _provider: IOCProvider = EmptyIOCProvider()
    
    public static var provider: IOCProvider {
        get { return _provider }
        set(value) {
            _provider = value
        }
    }
    
    public static func getInstance<T>(key: String? = nil) -> T? {
        if (key != nil) {
            return _provider.getInstance(key!) as T?
        } else {
            return _provider.getInstance() as T?
        }
    }
}

public protocol IOCProvider {
    func getInstance<T>() -> T?
    func getInstance<T>(key: String) -> T?
}

private class EmptyIOCProvider : IOCProvider {
    func getInstance<T>() -> T? { return nil }
    func getInstance<T>(key: String) -> T? { return nil }
}
