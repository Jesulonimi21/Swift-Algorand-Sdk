//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation
public struct TransactionAssetFreeze: Codable, Equatable {
    public var address: String?
    public var assetId: Int64?
    public var newFreezeStatus: Bool?
    
    enum CodingKeys: String, CodingKey {
        case assetId="asset-id"
        case newFreezeStatus="new-freeze-status"
        case address="address"
    }
}
