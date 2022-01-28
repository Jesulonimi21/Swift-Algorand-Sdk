//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public struct AssetHolding: Codable, Equatable {
    public var amount: Int64?
    public var assetId: Int64?
    public var creator: String?
    public var isFrozen: Bool?
    
    enum CodingKeys: String, CodingKey {
        case amount="amount"
        case assetId="asset-id"
        case creator="creator"
        case isFrozen="is-frozen"
        
    }

}
