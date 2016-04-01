//
//  Bootstrapper.swift
//  GelDeskMac
//
//  Created by Wayne on 2/19/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation
import GelDesk
import GelDeskCocoa
import GelDeskUI
import Dip

internal class Bootstrapper : BootstrapperBase, IOCProvider {
    
    override init() {
        _config = AppConfig.readCommandLineArgs()
        super.init()
        IOC.provider = self
        self.onConfigure(doConfigure)
        self.onStartup(doStartup)
    }
    
    private let _config: AppConfig
    
    private func doConfigure() {
        print("Bootstrapper.doConfigure")
        _container.register { return self._config }
        registerSingletons()
        registerComponentTypes()
    }
    
    private func doStartup() {
        print("Bootstrapper.doStartup")
        let pm = IOC.getInstance() as ProcessManager!
        pm.startup()
    }
    
    // IOC
    private let _container = DependencyContainer()
    
    func getInstance<T>() -> T? {
        do {
            return try _container.resolve() as T
        } catch let err {
            print("DependencyContainer..resolve error: \(err)")
            return nil
        }
    }
    func getInstance<T>(key: String) -> T? {
        let tag = DependencyContainer.Tag.String(key)
        do {
            return try _container.resolve(tag: tag) as T
        } catch let err {
            print("DependencyContainer..resolve error: \(err)")
            return nil
        }
    }
    
    private func registerComponentTypes() {
        let prefix = "geldesk.ui."
        let tag = DependencyContainer.Tag.String(prefix + "Window")
        _container.register(tag: tag) { WindowController() as ComponentObject }
    }
    
    private func registerSingletons() {
        let c = _container
        c.register(.Singleton) {
            RPCRouter()
        }
        c.register(.Singleton) {
            ComponentManager(
                router: try! c.resolve() as RPCRouter
            )
        }
        c.register(.Singleton) {
            ProcessManager(
                config: self._config,
                components: try! c.resolve() as ComponentManager
            )
        }
    }
    
}
