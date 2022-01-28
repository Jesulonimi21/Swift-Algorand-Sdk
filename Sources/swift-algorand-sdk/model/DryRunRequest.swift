//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/1/21.
//

import Foundation
public struct DryrunRequest: Codable, Equatable {
    
    public init() {
        
    }
    
    var accounts: [AccountData]?

    var apps: [Application]?

    /**
     * LatestTimestamp is available to some TEAL scripts. Defaults to the latest
     * confirmed timestamp this algod is attached to.
     */

    public var latestTimestamp: Int64?

    /**
     * ProtocolVersion specifies a specific version string to operate under, otherwise
     * whatever the current protocol of the network this algod is running in.
     */

    var protocolVersion: String?

    /**
     * Round is available to some TEAL scripts. Defaults to the current round on the
     * network this algod is attached to.
     */

    var round: Int64?

    public var sources: [DryrunSource]?
    public var txns: [SignedTransaction]?

    enum CodingKeys: String, CodingKey {
        case accounts = "accounts"
        case apps = "apps"
        case latestTimestamp = "latest-timestamp"
        case protocolVersion = "protocol-version"
        case round = "round"
        case txns = "txns"
        case sources = "sources"
        
    }

}
