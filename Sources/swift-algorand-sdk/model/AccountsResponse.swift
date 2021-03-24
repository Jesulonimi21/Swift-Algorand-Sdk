//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public class AccountsResponse : Codable {

    public var accounts:[AccountData]?
    public var currentRound:Int64?
    public var nextToken:String?
    
    enum CodingKeys : String,CodingKey{
        case currentRound = "current-round"
        case accounts = "accounts"
        case nextToken = "next-token"
    }
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }

}
