//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public struct AccountData: Codable, Equatable {
    public var address: String?

    public var amount: Int64?
     
    public var amountWithoutPendingRewards: Int64?
    
    public var appsLocalState: [ApplicationLocalState]?
      
    public var appsTotalSchema: ApplicationStateSchema?
       
    public var assets: [AssetHolding]?
    public var authAddr: String?

    public var createdApps: [Application]?

    public var createdAssets: [AssetData]?
    
    public var participation: AccountParticipation?
     
    public var pendingRewards: Int64?
     
    public var rewardBase: Int64?
    
    public var rewards: Int64?
     
    public var round: Int64?
      
    public var sigType: SigType?
     
    public var status: String?
    
    enum CodingKeys: String, CodingKey {
       case address = "address"
       case amount = "amount"
      case  amountWithoutPendingRewards = "amount-without-pending-rewards"
      case appsLocalState = "apps-local-state"
     case appsTotalSchema = "apps-total-schema"
     case  assets = "assets"
    case  authAddr = "auth-addr"
     case createdApps = "created-apps"
    case  createdAssets = "created-assets"
    case  participation =  "participation"
     case pendingRewards = "pending-rewards"
     case rewardBase  = "reward-base"
       case rewards = "rewards"
      case round = "round"
      case sigType = "sig-type"
      case status  = "status"
    }
}
