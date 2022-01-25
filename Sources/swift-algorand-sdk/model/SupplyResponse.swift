//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
public struct SupplyResponse:Codable, Equatable {
    
    /**
     * Round
     */

    public var current_round:Int64

    /**
     * OnlineMoney
     */

    public var onlineMoney:Int64?

    /**
     * TotalMoney
     */

    public var totalMoney:Int64?
    
    
    enum CodingKeys:String,CodingKey{
        case current_round = "current_round"
        case onlineMoney = "online-money"
        case totalMoney = "total-money"
    }
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try? jsonencoder.encode(self)
        var classString=String(data: classData ?? Data(), encoding: .utf8)
       return classString
    }
}
