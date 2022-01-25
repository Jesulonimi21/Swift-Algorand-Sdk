//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation
public struct TransactionAssetTranser:Codable, Equatable{
   
    public var amount:Int64?
    
    public var assetId:Int64?
    
    public var closeAmount:Int64?
    public var closeTo:String?
 
    public var receiver:String?

    public var sender:String?
    
    
    enum CodingKeys:String,CodingKey{
        case amount="amount"
        case assetId="asset-id"
        case closeAmount="close-amount"
        case closeTo="close-to"
        case receiver="receiver"
        case sender="sender"
    }
}
