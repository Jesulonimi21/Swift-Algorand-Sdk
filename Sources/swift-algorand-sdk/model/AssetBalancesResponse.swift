//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public struct AssetBalancesResponse: Codable, Equatable {
    public var balances: [MiniAssetHolding]?
    public var currentRound: Int64
    public var nextToken: String
    
    enum CodingKeys: String, CodingKey {
        case balances="balances"
        case currentRound="current-round"
        case nextToken="next-token"
    }
    
    public func toJson() throws -> String? {
        var jsonencoder=JSONEncoder()
        var classData=try jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
    
}
