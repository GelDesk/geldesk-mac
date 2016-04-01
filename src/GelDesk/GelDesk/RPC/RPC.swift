//
//  RPC.swift
//  GelDesk
//
//  Created by Wayne on 2/20/16.
//  Copyright © 2016 Devoptix LLC. All rights reserved.
//

import Foundation

public typealias RPCAction = (RPCContext) -> Void

public typealias RPCDataAction = (RPCChannel, data: NSString) -> Void

public typealias RPCMessageAction = (RPCMessage) -> Void

public protocol RPCChannel {
    func close()
    func open()
    func read(withAction: RPCDataAction?)
    func write(message: String)
}

public protocol RPCHandler {
    func handleRPC(rpc: RPCContext) -> Bool
}

public class RPCError {
    public let code: Int
    public let message: String?
    public let stack: String?
    
    public init(code: Int = 0, message: String? = nil, stack: String? = nil) {
        self.code = code
        if message != nil {
            self.message = message
        } else {
            self.message = RPCErrorCode.message(self.code)
        }
        self.stack = stack
    }
    
    public init(nsErr: NSError, stack: String? = nil) {
        // TODO: Check if nsErr.code in valid GelDesk error code range.
        code = 0
        message = nsErr.description
        self.stack = stack
    }
}

public enum RPCErrorCode: Int {
    case ReservedBegin = -32000
    case ReservedEnd = -32099
    case ParseError = -32700
    case InvalidRequest = -32600
    case InternalError = -32599
    case MethodNotFound = -32598
    case InvalidArgs = -32597
}

public enum RPCErrorType: ErrorType {
    case ParseError
    case InvalidRequest
    case InternalError
    case MethodNotFound
    case InvalidArgs
}

public extension RPCErrorCode {
    
    public static func toNSError(code: Int) -> NSError {
        return NSError(
            domain: ErrorDomain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: RPCErrorCode.message(code)])
    }
    
    public static func message(code: Int) -> String {
        if let e = RPCErrorCode(rawValue: code) {
            switch e {
            case .ParseError:
                return "Parse Error"
            case .InvalidRequest:
                return "InvalidRequest Error"
            case .InternalError:
                return "Internal Error"
            case .MethodNotFound:
                return "MethodNotFound Error"
            case .InvalidArgs:
                return "InvalidArgs Error"
            default:
                break
            }
        }
        return "Unknown Error Code: \(code)"
    }
}

public final class RPCPath {
    /// The separator used in rpc paths
    public static let separator = "/"
    /// Returns the given strings joined by `RPCPath.separator` ("/").
    public static func join(strings: [String?]) -> String {
        let strings2 = strings.map { s in s! }
        return strings2.joinWithSeparator(separator)
    }
    /// Returns the given strings joined by `RPCPath.separator` ("/").
    public static func join(strings: String?...) -> String {
        let strings2 = strings.map { s in s! }
        return strings2.joinWithSeparator(separator)
    }
    /// Returns the given strings joined by `RPCPath.separator` ("/").
    public static func join(strings: String...) -> String {
        return strings.joinWithSeparator(separator)
    }
    /// Returns the given strings joined by `RPCPath.separator` ("/").
    public static func join(strings: [String]) -> String {
        return strings.joinWithSeparator(separator)
    }
    /// Returns an array of path parts separated by `RPCPath.separator` ("/").
    public static func split(path: String?) -> [String] {
        // See http://stackoverflow.com/a/25678505/16387
        return path!.componentsSeparatedByString(separator)
        //return path!.characters.split("/").map(String.init)
    }
}
