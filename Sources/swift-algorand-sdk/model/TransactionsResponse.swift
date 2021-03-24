//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
public class TransactionsResponse :  Codable {
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
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }


}
