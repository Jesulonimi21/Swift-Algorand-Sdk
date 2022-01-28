//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/1/21.
//

import Foundation
public struct DryrunResponse: Codable, Equatable {

    public var error: String?

    /**
     * Protocol version is the protocol version Dryrun was operated under.
     */

    public var protocolVersion: String?

    public var txns: [DryrunTxnResult]?

    enum CodingKeys: String, CodingKey {
        case txns = "txns"
        case protocolVersion = "protocol-version"
        case error = "error"
    }
    
    public func toJson() -> String? {
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
}
