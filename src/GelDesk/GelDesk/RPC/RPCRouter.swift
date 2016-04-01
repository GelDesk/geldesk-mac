//
//  RPCRouter.swift
//  GelDesk
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public class RPCRouter {
    
    private var _handlers = [RPCHandler]()
    
    public init() { }
    
    public func addHandler(handler: RPCHandler) {
        print("RPCRouter.addHandler")
        _handlers.append(handler)
    }
    
    public func handleRPC(context: RPCContext) -> Bool {
        for handler in _handlers {
            if (handler.handleRPC(context)) {
                return true
            }
        }
        return false
    }
}
