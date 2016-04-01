//
//  RPCMessage.swift
//  GelDesk
//
//  Created by Wayne on 3/16/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public struct RPCMessage {
    public var path: String?
    public var arguments: [AnyObject]?
    public var requestId: Int
    public var error: NSError?
}

// MARK: Computed Fields

public extension RPCMessage {
    
    public var hasError: Bool { return error != nil }
    
    public var isNotification : Bool {
        get { return path != nil && requestId < 0 }
        set(value) { requestId = value ? -1 : 0 }
    }
    
    public var isRequest: Bool { return path != nil && requestId > -1 }
    
    public var isResponse: Bool { return path == nil }
    
}

// MARK: JSON

public extension RPCMessage {

    public static func decode(frame: String) throws -> RPCMessage {
        let fa = try GStr.decodeJSON(frame, options: []) as! NSArray
        let count = fa.count
        // Message Parts
        var path: String? = nil
        var args: [AnyObject]? = nil
        var reqId: Int = 0
        var err: NSError? = nil
        if count > 0 {
            reqId = fa[count - 1] as! Int
        }
        if count > 1 {
            args = fa[count - 2] as? [AnyObject]
        }
        if count > 2 {
            path = fa[count - 3] as? String
        }
        // If the message is a Response (nil path) and there are arguments,
        // extract the first argument as an error.
        if path == nil && args != nil && args!.count > 0 {
            if let code = args![0] as? Int {
                err = RPCErrorCode.toNSError(code)
            } else if let errObj = args![0] as? [String: AnyObject] {
                err = decodeNSError(errObj)
            }
            args!.removeAtIndex(0)
        }
        let msg = RPCMessage(
            path: path,
            arguments: args,
            requestId: reqId,
            error: err)
        return msg
    }
    
    public static func decodeNSError(errObj: [String: AnyObject]) -> NSError {
        let code = errObj["code"] as? Int ?? 0
        let msg = errObj["message"] as? String ?? RPCErrorCode.message(code)
        let userInfo: [NSObject: AnyObject]? = [NSLocalizedDescriptionKey: msg]
        return NSError(domain: ErrorDomain, code: code, userInfo: userInfo)
    }
    
    public static func encode(message: RPCMessage) -> String {
        var frame: [AnyObject] = []
        var args: [AnyObject] = message.arguments ?? []
        if !message.isResponse {
            frame.append(message.path!)
        }
        if !message.isRequest {
            if let nsErr = message.error {
                if nsErr.code != 0 {
                    // TODO: && nsErr.code in valid GelDesk error code range.
                    args.insert(nsErr.code, atIndex: 0)
                } else {
                    let rpcErr = RPCError(nsErr: nsErr)
                    args.insert(rpcErr, atIndex: 0)
                }
            } else if !message.isNotification {
                args.insert(NSNull(), atIndex: 0)
            }
        }
        frame.append(args)
        frame.append(message.requestId)
        let nsData = try! NSJSONSerialization.dataWithJSONObject(
            frame,
            options: [])
        return NSString(data: nsData, encoding: NSUTF8StringEncoding) as! String
    }
}
