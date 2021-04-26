//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/7/21.
//

import Foundation
public class SignedTransaction: Codable,Equatable {
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
    
   
    public required init(from decoder: Decoder) throws {
                var container = try! decoder.container(keyedBy: CodingKeys.self);
                self.tx =  try? container.decode(Transaction.self, forKey: .tx)
                self.sig = try? container.decode(Signature.self, forKey: .sig)
                self.mSig = try? container.decode(MultisigSignature.self, forKey: .mSig)
                self.lSig = try? container.decode(LogicsigSignature.self, forKey: .lSig)
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let lSig=self.lSig{
            if lSig.logic == nil && lSig.args == nil && lSig.sig ==  nil && lSig.msig == nil{
                
            }else{
                try! container.encode(lSig, forKey: .lSig)
            }
           
        }
        if let mSig=self.mSig{
            if (mSig.subsigs?.count==0 && mSig.version == nil && mSig.threshold == nil){
                
            }else{
                try! container.encode(mSig, forKey: .mSig)
            }
        
        }
        if let sig=self.sig{
            if let sigBytes = sig.bytes{
                try! container.encode(Data(CustomEncoder.convertToUInt8Array(input:sig.getBytes())), forKey: .sig)
            }
        
        }
      
        if let tx=self.tx{
            try! container.encode(tx, forKey: .tx)
        }
        
       
    }
    
    
    
    public init(sig:Signature,tx:Transaction){
        self.tx=tx
        self.sig=sig
    }
    
    public   init(tx:Transaction,mSig:MultisigSignature,txId:String){
        self.tx=tx
        self.mSig=mSig
        self.transactionID=txId
    }
    public   init(tx:Transaction,sig:Signature,mSig:MultisigSignature,lSig:LogicsigSignature, txId:String){
        self.tx=tx
        self.mSig=mSig
        self.transactionID=txId
        self.lSig=lSig
        self.sig=sig
    }
    public  init(tx:Transaction,lSig:LogicsigSignature,txId:String){
        self.tx=tx
        self.lSig=lSig
        self.transactionID=txId
    }
    
    public init(tx:Transaction,lsig:LogicsigSignature){
        self.tx=tx
        self.lSig=lsig
    }
    
    public  init(tx:Transaction,sig:Signature,txId:String){
        self.tx=tx
        self.sig=sig
        self.transactionID=txId
    }
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
    
    public static func == (lhs: SignedTransaction,rhs:SignedTransaction) -> Bool{
        print("Sg check")
//        print(lhs.tx==rhs.tx)
//        print(lhs.lSig==rhs.lSig)
//        print(lhs.mSig==rhs.mSig)
//        print(lhs.sig==rhs.sig)
        print("Sg end")
        return lhs.tx==rhs.tx && lhs.lSig==rhs.lSig && lhs.mSig==rhs.mSig && lhs.sig==rhs.sig
    }
}
