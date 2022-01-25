//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public struct BlockUpgradeState: Codable, Equatable {
    public var currentProtocol: String?
    public var nextProtocol: String?
    public var nextProtocolApprovals: Int64?
    public var nextProtocolSwitchOn: Int64?
  
    public var nextProtocolVoteBefore: Int64?
    
    enum CodingKeys: String, CodingKey {
        case currentProtocol = "current-protocol"
        case nextProtocol = "next-protocol"
        case nextProtocolApprovals = "next-protocol-approvals"
        case nextProtocolSwitchOn = "next-protocol-switch-on"
        case nextProtocolVoteBefore = "next-protocol-vote-before"
        
    }
}
