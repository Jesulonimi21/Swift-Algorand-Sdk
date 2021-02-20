//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/7/21.
//

import Foundation
public class SignedTransaction: Codable {
    var  tx:Transaction;
    var sig:Signature?;
    var transactionID:String?
    var mSig:MultisigSignature?

    enum CodingKeys:String, CodingKey{
        case tx = "txn"
        case sig = "sig"
        case mSig="msig"
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let sig=self.sig{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input:sig.getBytes())), forKey: .sig)
        }
        if let mSig=self.mSig{
            try! container.encode(mSig, forKey: .mSig)
        }
       
        try! container.encode(self.tx, forKey: .tx)
    }
    
    init(sig:Signature,tx:Transaction){
        self.tx=tx
        self.sig=sig
    }
    
    init(tx:Transaction,mSig:MultisigSignature,txId:String){
        self.tx=tx
        self.mSig=mSig
        self.transactionID=txId
    }

   
}
