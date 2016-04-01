//
//  ChildProcess.swift
//  GelDesk
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//
import Foundation

public class ChildProcess {
    
    public init(config: ChildProcessConfig) {
        _config = config
    }
    
    private let _config: ChildProcessConfig
    
    private var _connection: RPCConnection?
    private var _manager: ProcessManager?
    private var _task: NSTask!
    private var _errPipe: NSPipe!
    private var _errHandle: NSFileHandle!
    
    private func channelReadNonRPC(channel: RPCChannel, data: NSString) {
        print("proc-in: \(data)")
    }
    
    @objc private func taskErrorDataAvailable(notification: NSNotification) {
        let data = _errHandle.availableData
        if data.length == 0 {
            print("proc: EOF on stderr")
            removeObserver(
                self,
                NSFileHandleDataAvailableNotification,
                _errHandle)
            return
        }
        if let str = NSString(data: data, encoding: NSUTF8StringEncoding){
            let str2 = str.substringToIndex(str.length - 1)
            print("proc-err: \(str2)")
        }
    }
    
    private func createTask() {
        _task = NSTask()
        _task.launchPath = _config.command
        _task.arguments = _config.arguments
        if let cwd = _config.workingDirectory {
            _task.currentDirectoryPath = cwd
        }
        print("ChildProcess.createTask" +
            ":\n  for '\(GStr.ifNil(_config.command))'" +
            "\n  in '\(GStr.ifNil(_config.workingDirectory))'" +
            "\n  with arguments \(_config.arguments)")
        _errPipe = NSPipe()
        _errHandle = _errPipe.fileHandleForReading
        _task.standardError = _errPipe
        _errHandle.waitForDataInBackgroundAndNotify()
        observe(
            self,
            #selector(taskErrorDataAvailable),
            NSFileHandleDataAvailableNotification,
            _errHandle)
        observe(
            self,
            #selector(taskDidTerminate),
            NSTaskDidTerminateNotification,
            _task)
    }
    
    private func initializeConnection() {
        let channel = RPCStdIOChannel(task: _task)
        channel.readNonRPC(channelReadNonRPC)
        _connection = RPCConnection(channel: channel)
    }
    
    public func start(manager: ProcessManager) {
        //NSLog("%@", NSThread.currentThread())
        _manager = manager
        createTask()
        initializeConnection()
        _task.launch()
        _connection?.open()
        _manager?.onChildStarted(self)
        _connection?.notify("process/connected")
    }
    
    @objc private func taskDidTerminate(notification: NSNotification) {
        print("ChildProcess.taskDidTerminate")
        _manager?.onChildStopped(self)
        removeObserver(
            self,
            NSTaskDidTerminateNotification,
            _task)
    }
}

extension ChildProcess {
    static func createAll(src: [ChildProcessConfig]?) -> [ChildProcess] {
        guard let configs = src else {
            return []
        }
        let procs = configs.map { cfg in ChildProcess(config: cfg) }
        return procs
    }
}

