//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public class BlockRewards : Codable{
    public var feeSink:String?
    public var rewardsCalculationRound:Int64?
    public var rewardsLevel:Int64?
    public var rewardsPool:String?
    public var rewardsRate:Int64?
    public var rewardsResidue:Int64?
    
    enum CodingKeys:String,CodingKey{
        case feeSink = "fee-sink"
        case rewardsCalculationRound = "rewards-calculation-round"
        case rewardsLevel = "rewards-level"
        case rewardsPool = "rewards-pool"
        case rewardsRate = "rewards-rate"
        case rewardsResidue = "rewards-residue"
    }
}
