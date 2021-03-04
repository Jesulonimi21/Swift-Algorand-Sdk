//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation
public class TransactionAssetFreeze:Codable{
    public var address:String?;
    public var assetId:Int64?;
    public var newFreezeStatus:Bool?;

    
    enum CodingKeys:String,CodingKey{
        case assetId="asset-id"
        case newFreezeStatus="new-freeze-status"
        case address="address"
    }
}
