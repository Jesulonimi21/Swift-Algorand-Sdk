//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public class AssetBalancesResponse:Codable{
    public var balances:[MiniAssetHolding]?
    public var currentRound:Int64;
    public var nextToken:String;
    
    enum CodingKeys:String,CodingKey{
        case balances="balances"
        case currentRound="current-round"
        case nextToken="next-token"
    }
}
