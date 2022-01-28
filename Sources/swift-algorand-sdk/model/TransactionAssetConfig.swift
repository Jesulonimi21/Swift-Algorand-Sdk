//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation
public struct TransactionAssetConfig: Codable, Equatable {
    public var assetId: Int64
    public var assetParams: AssetParams
    
    enum  CodingKeys: String, CodingKey {
        case assetId="asset-id"
        case assetParams="params"
    }
}
