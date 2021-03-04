//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation

public class AccountResponse : Decodable {

    public var account:AccountData?
    public var currentRound:Int64?
    
    enum CodingKeys : String,CodingKey{
        case currentRound = "current-round"
        case account = "account"
    }

}
