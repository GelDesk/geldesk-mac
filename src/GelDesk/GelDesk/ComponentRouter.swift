//
//  ComponentRouter.swift
//  GelDesk
//
//  Created by Wayne on 2/20/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public class ComponentRouter : RPCHandler {
    
    public init(components: ComponentCollection) {
        _components = components
    }
    
    private var _components : ComponentCollection
    
    public func handleRPC(rpc: RPCContext) -> Bool {
        return false
    }
    
}
