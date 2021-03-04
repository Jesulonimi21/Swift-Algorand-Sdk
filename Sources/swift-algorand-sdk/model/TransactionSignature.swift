//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation
public class TransactionSignature:Codable{
    public var logicsig:TransactionSignatureLogicsig?
    public var multisig:TransactionSignatureMultisig?
    public var sig:[Int8]?
    
    
    enum CodingKeys:String,CodingKey{
        case logicsig="logicsig"
        case multisig="multisig"
        case sig="sig"
    }
    
    
    public required init(from decoder: Decoder) throws {
        var container = try! decoder.container(keyedBy: CodingKeys.self)
        var signatureString = try! container.decode(String.self, forKey: .sig)
        self.multisig = try? container.decode(TransactionSignatureMultisig.self, forKey: .multisig)
        self.logicsig = try? container.decode(TransactionSignatureLogicsig.self, forKey: .logicsig)
        self.sig=CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: signatureString))
    }
}
