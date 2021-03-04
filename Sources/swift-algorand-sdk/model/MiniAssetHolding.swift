//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public class MiniAssetHolding:Codable{
    public var address:Address?;
    public var amount:Int64?;
    public var isFrozen:Int?;
    
    enum CadingKeys:String,CodingKey{
        case address="address"
        case amount="amount"
        case isFrozen="is-frozen"
    }
    
    public required init(from decoder: Decoder) throws {
        var container = try?  decoder.container(keyedBy: CodingKeys.self)
        var base32Addr=try? container!.decode(String.self, forKey: .address)
        self.address = try? Address(base32Addr!);
        self.amount = try? container!.decode(Int64.self, forKey: .amount)
        self.isFrozen=try? container!.decode(Int.self, forKey: .isFrozen)
    }
    
    

}
