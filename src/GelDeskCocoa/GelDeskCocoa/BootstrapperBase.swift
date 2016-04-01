//
//  BootstrapperBase.swift
//  GelDesk
//
//  Created by Wayne on 2/19/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation
import GelDesk

public class BootstrapperBase {
    
    public enum Error: ErrorType {
        case AlreadyInitializedApp
    }
    
    public init() { }
    
    // Handlers
    private var _onConfigure = EmptyActionHandler
    private var _onStartup = EmptyActionHandler
    
    public func onConfigure(handler: ActionHandler) {
        _onConfigure = handler
    }
    
    public func onStartup(handler: ActionHandler) {
        _onStartup = handler
    }
    
    // App Initialization
    private var _initialized = false
    
    public func initializeApp() throws {
        print("BootstrapperBase.initializeApp")
        if (_initialized) {
            throw Error.AlreadyInitializedApp
        }
        _initialized = true;
        _onConfigure()
        _onStartup()
    }
    
}
