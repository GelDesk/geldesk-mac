//
//  ComponentManager.swift
//  GelDesk
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public class ComponentManager {
    
    public init(router: RPCRouter) {
        _components = ComponentCollection()
        
        configureComponentRouter(router)
        configureController()
    }
    /**
     The root collection of components.
     */
    private var _components : ComponentCollection
    
    public func addComponent(component: ComponentType) {
        try! _components.add(component)
    }
    
    private func configureComponentRouter(router: RPCRouter) {
        let coRouter = ComponentRouter(components: _components)
        router.addHandler(coRouter)
    }
    
    private func configureController() {
        let controller = ComponentManagerController(manager: self)
        addComponent(controller)
    }
}

public class ComponentManagerController : ComponentObject {
    
    public init(manager: ComponentManager) {
        _manager = manager
        super.init(name: "component")
    }
    
    private let _manager: ComponentManager
    
    public func load(rpc: RPCContext) {
//        let result = _manager.initAndLoad(rpc, rpc.message.arguments)
//        rpc.Respond(result)
    }
}
