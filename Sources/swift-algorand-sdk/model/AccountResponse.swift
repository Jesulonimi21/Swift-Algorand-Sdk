//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation

public struct AccountResponse: Codable, Equatable {

    public var account: AccountData?
    public var currentRound: Int64?
    
    enum CodingKeys: String, CodingKey {
        case currentRound = "current-round"
        case account = "account"
    }
    
    public func toJson() -> String? {
        var jsonencoder=JSONEncoder()
        var classData=try? jsonencoder.encode(self)
        var classString=String(data: classData ?? Data(), encoding: .utf8)
       return classString
    }

}
