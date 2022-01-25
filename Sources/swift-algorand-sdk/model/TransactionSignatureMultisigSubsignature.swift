//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation
public struct TransactionSignatureMultisigSubsignature:Codable, Equatable {
    public var publicKey:[Int8]?
    public var signature:[Int8]?
    
    enum CodingKeys:String,CodingKey{
        case publicKey="public-key"
        case signature="signature"
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        var publicKeyString = try container.decode(String.self, forKey: .publicKey)
        var signatureString = try container.decode(String.self, forKey: .signature)
        
        self.publicKey=CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: publicKeyString))
        self.signature=CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: signatureString))
    }
    
  
}
