//
//  RPCStdIOChannel.swift
//  GelDesk
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public class RPCStdIOChannel : RPCChannel {
    
    public init(task: NSTask) {
        _task = task
        _writePipe = NSPipe()
        _writeHandle = _writePipe.fileHandleForWriting
        _readPipe = NSPipe()
        _readHandle = _readPipe.fileHandleForReading
        _opened = true
        
        _task.standardInput = _writePipe
        _task.standardOutput = _readPipe
        _readHandle.waitForDataInBackgroundAndNotify()
        observe(
            self,
            #selector(readHandleDataAvailable),
            NSFileHandleDataAvailableNotification,
            _readHandle)
    }
    
    private let _task: NSTask
    
    private let _readPipe: NSPipe
    private let _readHandle: NSFileHandle
    
    private let _writePipe: NSPipe
    private let _writeHandle: NSFileHandle
    
    private var _opened: Bool
    
    private var _read: RPCDataAction?
    private var _readNonRPC: RPCDataAction?
    
    public static let frameBegin = "@geldesk:"
    public static let frameBeginLength = 9 // length of frameBegin
    public static let frameEnd = "\n"
    public static let frameEndLength = 1
    
    public func close() {
        if (!_opened) {
            return
        }
        _opened = false
        // CONSIDER: Do we have to flush _writeHandle or _writePipe?
        // I don't think so...but there is _writeHandle.synchronizeFile().
    }
    
    public func open() {
        if (!_opened) {
            _opened = true
        }
    }
    
    public func read(withAction: RPCDataAction?) {
        _read = withAction
    }
    
    @objc private func readHandleDataAvailable(notification: NSNotification) {
        //NSLog("%@", NSThread.currentThread())
        let data = _readHandle.availableData
        if data.length > 0 {
            if let str = NSString(
                data: data,
                encoding: NSUTF8StringEncoding)
            {
                if (!str.hasPrefix(RPCStdIOChannel.frameBegin)) {
                    _readNonRPC?(
                        self,
                        data: str.substringToIndex(str.length -
                            RPCStdIOChannel.frameEndLength))
                } else if _opened {
                    _read?(
                        self,
                        data: str.substringFromIndex(
                            RPCStdIOChannel.frameBeginLength))
                }
            }
            _readHandle.waitForDataInBackgroundAndNotify()
        } else {
            print("proc: EOF on stdout")
            removeObserver(
                self,
                NSFileHandleDataAvailableNotification,
                _readHandle)
        }
    }
    
    public func readNonRPC(withAction: RPCDataAction?) {
        _readNonRPC = withAction
    }
    
    public func write(message: String) {
        if !_opened {
            return
        }
        let frame = RPCStdIOChannel.frameBegin + message +
            RPCStdIOChannel.frameEnd
        let data = frame.dataUsingEncoding(NSUTF8StringEncoding)!
        _writeHandle.writeData(data)
    }
    
}
