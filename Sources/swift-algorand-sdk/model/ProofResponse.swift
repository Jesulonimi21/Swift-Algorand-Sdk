//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
public struct ProofResponse: Codable, Equatable {
    
    /**
     * Index of the transaction in the block's payset.
     */
 
    public var idx: Int64?

    /**
     * Merkle proof of transaction membership.
     */
 
    public var proof: [Int8]?

    /**
     * Hash of SignedTxnInBlock for verifying proof.
     */
  
    public var stibhash: [Int8]?
    
    enum CodingKeys: String, CodingKey {
        case proof = "proof"
        case stibhash = "stibhash"
        case idx = "idx"
    }
    init() {}
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var proof = try? container.decode(String.self, forKey: .proof)
        if let p = proof {
            self.proof = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: p))
        }
        
        var stibhash = try? container.decode(String.self, forKey: .stibhash)
        if let s = stibhash {
            self.stibhash = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: s))
        }
        
        self.idx = try? container.decode(Int64.self, forKey: .idx)
    }
    
    public func toJson() -> String? {
        var jsonencoder=JSONEncoder()
        var classData=try? jsonencoder.encode(self)
        var classString=String(data: classData ?? Data(), encoding: .utf8)
       return classString
    }
}
