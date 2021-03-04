//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
public class TransactionsResponse : Decodable {
    public var currentRound:Int64?;
    public var nextToken:String?;
    public var transactions:[TransactionData]?
    
    
    enum CodingKeys:String,CodingKey{
        case currentRound="current-round"
        case nextToken="next-token"
        case transactions="transactions"
    }
    
    init() {
    }

}
