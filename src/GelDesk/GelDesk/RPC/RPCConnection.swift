//
//  RPCConnection.swift
//  GelDesk
//
//  Created by Wayne on 2/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

// MARK: Connection

public class RPCConnection {
    
    public init(channel: RPCChannel) {
        _channel = channel
        _router = IOC.getInstance()! as RPCRouter
    }
    private let _channel: RPCChannel
    private let _router: RPCRouter
    private var _opened: Bool = false
    private var _sentRequestCount: Int = 0
    private var _sentPendingResponse = [Int: RPCMessageAction]()
}

// MARK: Open & Close

public extension RPCConnection {
    
    public func close() {
        if !_opened {
            return
        }
        _channel.close()
        _channel.read(nil)
        _opened = false
    }
    
    public func open() {
        if _opened {
            return
        }
        _opened = true
        _channel.read(receive)
        _channel.open()
    }
    
}

// MARK: Send & Receive

public extension RPCConnection {
    
    private func receive(channel: RPCChannel, data: NSString) {
        print("rpc-in: \(data)")
        let msg: RPCMessage!
        do {
            msg = try RPCMessage.decode(data as String)
        } catch let readErr as NSError {
            print("rpc-in: error")
            print(readErr)
            return
        }
        if msg.isResponse {
            receiveResponse(msg)
        } else {
            receiveRequestOrNotification(msg)
        }
    }
    
    private func receiveRequestOrNotification(message: RPCMessage) {
        let context = RPCContext(connection: self, message: message)
        if !_router.handleRPC(context) {
            print("rpc-err: FAILED TO HANDLE RPC")
        }
    }
    
    private func receiveResponse(message: RPCMessage) {
        // TODO: Multi-threading - Lock around _sentPendingResponse
        guard let handler =
            _sentPendingResponse.removeValueForKey(message.requestId) else {
            // TODO: Error - Method not found.
            return
        }
        do {
            handler(message)
        } catch let handlerErr as NSError {
            print("rpc-in: Response handler error")
            print(handlerErr)
        }
    }
    
    public func send(message: RPCMessage) {
        if !_opened {
            return
        }
        let messageJSON = RPCMessage.encode(message)
        print("rpc-out: " + messageJSON)
        _channel.write(messageJSON)
    }
    
    internal func write(data: String) {
        _channel.write(data)
    }
    
}

// MARK: Request & Response

public extension RPCConnection {
    
    public func request(
        message: RPCMessage,
        resultHandler: RPCMessageAction)
        -> Bool
    {
        guard message.isRequest else {
            // TODO: Error - Message must be a request.
            return false
        }
        guard _opened else {
            // TODO: Error - Connection not open.
            return false
        }
        // TODO: Multi-threading - Locks around _sentRequestId and
        // _sentPendingResponse...
        _sentRequestCount += 1
        let requestId = _sentRequestCount
        _sentPendingResponse[requestId] = resultHandler
        
        send(message)
        return true
    }
    
    public func respond(message: RPCMessage) {
        if !message.isResponse {
            return
        }
        send(message)
    }
    
}

// MARK: Notification

public extension RPCConnection {
    
    public func notify(error: NSError) {
        // TODO: Decide a better default global path for errors.
        let defaultErrorsPath = "errors"
        let msg = RPCMessage(
            path: defaultErrorsPath,
            arguments: nil,
            requestId: -1,
            error: error)
        send(msg)
    }
    
    public func notify(message: RPCMessage) {
        if !message.isNotification {
            // CONSIDER: Error - Message must be a notification.
            // CONSIDER: Set isNotification to true here.
            return
        }
        send(message)
    }
    
    public func notify(path: String, arguments: AnyObject...) {
        let msg = RPCMessage(
            path: path,
            arguments: arguments,
            requestId: -1,
            error: nil)
        send(msg)
    }
    
    public func notify(path: String, arguments: [AnyObject]) {
        let msg = RPCMessage(
            path: path,
            arguments: arguments,
            requestId: -1,
            error: nil)
        send(msg)
    }
    
    public func notify(path: String, error: NSError) {
        let msg = RPCMessage(
            path: path,
            arguments: nil,
            requestId: -1,
            error: error)
        send(msg)
    }
    
}
