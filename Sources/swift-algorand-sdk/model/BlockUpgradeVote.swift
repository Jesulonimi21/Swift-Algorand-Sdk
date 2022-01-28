//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public struct BlockUpgradeVote: Codable, Equatable {
    public var upgradeApprove: Bool?
    public var upgradeDelay: Int64?
    public var upgradePropose: String?
    
    enum CodingKeys: String, CodingKey {
        case upgradeApprove = "upgrade-approve"
        case upgradeDelay = "upgrade-delay"
        case upgradePropose = "upgrade-propose"
        
    }
    
}
