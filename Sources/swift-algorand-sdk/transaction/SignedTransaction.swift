//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/7/21.
//

import Foundation
public class SignedTransaction: Codable {
   public var  tx:Transaction?;
    public var sig:Signature?;
    public var transactionID:String?
    public  var mSig:MultisigSignature?
    public var lSig:LogicsigSignature?
    enum CodingKeys:String, CodingKey{
        case tx = "txn"
        case sig = "sig"
        case mSig="msig"
        case lSig="lsig"
    }
    
    init(){
        
    }
    
//    public required init(from decoder: Decoder) throws {
//        var container = try! decoder.container(keyedBy: CodingKeys.self);
//        self.tx =  try! container.decode(Transaction.self, forKey: .tx)
//        self.sig = try! container.decode(Signature.self, forKey: .sig)
//        self.mSig = try! container.decode(MultisigSignature.self, forKey: .mSig)
//    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let lSig=self.lSig{
            try! container.encode(lSig, forKey: .lSig)
        }
        if let mSig=self.mSig{
            try! container.encode(mSig, forKey: .mSig)
        }
        if let sig=self.sig{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input:sig.getBytes())), forKey: .sig)
        }
      
        if let tx=self.tx{
            try! container.encode(tx, forKey: .tx)
        }
        
       
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
    init(tx:Transaction,lSig:LogicsigSignature,txId:String){
        self.tx=tx
        self.lSig=lSig
        self.transactionID=txId
    }

   
}
