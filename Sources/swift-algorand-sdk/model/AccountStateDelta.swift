//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation

public struct AccountStateDelta: Codable, Equatable {
    public var address: Address?
 
    public  var delta: [EvalDeltaKeyValue]?

    init() {
    }
    
    enum CodingKeys: String, CodingKey {
        case address="address"
        case delta="delta"
    }
    
    public init(from decoder: Decoder) throws {
        var container=try! decoder.container(keyedBy: CodingKeys.self)
        let strAddr=try! container.decode(String.self, forKey: .address)
        self.address=try! Address(strAddr)
        
    }

}
