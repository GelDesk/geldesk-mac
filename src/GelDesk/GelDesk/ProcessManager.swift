//
//  ProcessManager.swift
//  GelDesk
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public class ProcessManager {
    
    public init(config: AppConfig, components: ComponentManager) {
        _config = config
        _childProcesses = ChildProcess.createAll(_config.childProcesses)
    }
    
    let _config: AppConfig
    var _childProcesses: [ChildProcess]
    
    public func startup() {
        print("ProcessManager.doStartup")
        startupChildProcesses()
    }
    
    private func startupChildProcesses() {
        let procs = _childProcesses
        for proc in procs {
            proc.start(self)
        }
    }
    
    private func onAllChildrenStopped() {
        print("ProcessManager.onAllChildrenStopped")
    }
    
    internal func onChildStarted(proc: ChildProcess) {
        print("ProcessManager.onChildStarted")
        // TODO: proc.connection.notify("process/connected")
    }
    
    internal func onChildStopped(proc: ChildProcess) {
        print("ProcessManager.onChildStopped")
        guard let i = _childProcesses.indexOf({
            item in
            item === proc
        }) else { return }
        _childProcesses.removeAtIndex(i)
        if _childProcesses.count == 0 {
            onAllChildrenStopped()
        }
    }
}