//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public class AccountParticipation : Codable{
    public var selectionParticipationKey:[Int8]?
    public var voteFirstValid:Int64?
    public var voteKeyDilution:Int64?
    public var voteLastValid:Int64?
    public var voteParticipationKey:[Int8]?
    
    
    enum CodingKeys:String,CodingKey{
        case voteFirstValid = "vote-first-valid"
        case voteKeyDilution = "vote-key-dilution"
        case voteLastValid = "vote-last-valid"
        case selectionParticipationKey = "selection-participation-key"
        case voteParticipationKey = "vote-participation-key"
    }
    
    
    public required init(from decoder: Decoder) throws {
        var container =  try! decoder.container(keyedBy: CodingKeys.self)
        self.voteLastValid = try! container.decode(Int64.self, forKey: .voteLastValid)
        self.voteFirstValid = try! container.decode(Int64.self, forKey: .voteFirstValid)
        self.voteKeyDilution = try! container.decode(Int64.self, forKey: .voteKeyDilution)
        
        var voteParticipationKeyString = try! container.decode(String.self, forKey: .voteParticipationKey)
        self.voteParticipationKey = CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: voteParticipationKeyString))
        var selectionParticipationKeyString = try! container.decode(String.self, forKey: .selectionParticipationKey)
        self.selectionParticipationKey = CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: selectionParticipationKeyString))
    }

}
