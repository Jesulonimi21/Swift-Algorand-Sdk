//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/18/21.
//

import Foundation
import Ed25519
public class MultisigSignature : Codable,Equatable {
    var SIGN_ALGO = "EdDSA";
    var  MULTISIG_VERSION:Int = 1;
  public  var version:Int?;
  public  var threshold:Int?;
public    var subsigs:[MultisigSubsig]?=[MultisigSubsig]();
  public  var alphabetic=true
    enum CodingKeys:String,CodingKey{
        case subsigs="subsig"
        case threshold="thr"
        case version="v"
        
    }

  public  init(version:Int, threshold:Int,  subsigs:[MultisigSubsig]?) {
        self.subsigs = subsigs;
        self.threshold = threshold
        self.version = version;
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(subsigs, forKey: .subsigs)
        try container.encode(threshold, forKey: .threshold)
        try container.encode(version, forKey: .version)

       
    }
    
    public required init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        self.version = try  container.decode(Int.self, forKey: .version)
        self.threshold = try container.decode(Int.self,forKey: .threshold)
        self.subsigs =  try container.decode([MultisigSubsig].self,forKey: .subsigs)
        

    }

    convenience init(version:Int, threshold:Int) {
        self.init(version: version, threshold: threshold, subsigs: [MultisigSubsig]());
    }
    
    

 public   init() {
        self.subsigs=[MultisigSubsig]();
    }
    
    public func verify(message:[Int8])->Bool{
        if self.version==1 && self.threshold! > 0 && self.subsigs?.count != 0 {
            if(self.threshold!>self.subsigs!.count){
                return false
            } else{
                var verifiedCount = 0;
                var emptySig = Signature()
                for i in 0..<self.subsigs!.count{
                    var subsig:MultisigSubsig = self.subsigs![i]
                    if(subsig.sig?.bytes != nil){
                        let publicKey = try! PublicKey(CustomEncoder.convertToUInt8Array(input: (subsig.key?.getBytes())!))
                     
                       
                        var isVerified = try! publicKey.verify(signature: CustomEncoder.convertToUInt8Array(input: subsig.sig!.bytes!), message: CustomEncoder.convertToUInt8Array(input: message))
                        if isVerified{
                            verifiedCount = verifiedCount + 1
                            
                        }
                        
                    }
                }
              
            if (verifiedCount < self.threshold!) {
                return false;
            } else {
                return true;
            }
            }
        }
        return false
    }

//    public boolean verify(byte[] message) {
//        if (this.version == 1 && this.threshold > 0 && this.subsigs.size() != 0) {
//            if (this.threshold > this.subsigs.size()) {
//                return false;
//            } else {
//                int verifiedCount = 0;
//                Signature emptySig = new Signature();
//
//                for(int i = 0; i < this.subsigs.size(); ++i) {
//                    MultisigSignature.MultisigSubsig subsig = (MultisigSignature.MultisigSubsig)this.subsigs.get(i);
//                    if (!subsig.sig.equals(emptySig)) {
//                        try {
//                            PublicKey pk = (new Address(subsig.key.getBytes())).toVerifyKey();
//                            java.security.Signature sig = java.security.Signature.getInstance("EdDSA");
//                            sig.initVerify(pk);
//                            sig.update(message);
//                            boolean verified = sig.verify(subsig.sig.getBytes());
//                            if (verified) {
//                                ++verifiedCount;
//                            }
//                        } catch (Exception var9) {
//                            throw new IllegalStateException("verification of subsig " + i + "failed", var9);
//                        }
//                    }
//                }
//
//                if (verifiedCount < this.threshold) {
//                    return false;
//                } else {
//                    return true;
//                }
//            }
//        } else {
//            return false;
//        }
//    }

    public static func ==(lh:MultisigSignature,rh:MultisigSignature)-> Bool{
        return lh.subsigs==rh.subsigs&&lh.MULTISIG_VERSION==rh.MULTISIG_VERSION&&lh.threshold==rh.threshold&&lh.version==rh.version
        
    }
    
    }

   
    public  class MultisigSubsig :Codable,Equatable{
 
        var key:Ed25519PublicKey?;

        var sig:Signature?;

        enum CodingKeys:String,CodingKey{
            case key="pk"
            case sig="s"
        }
        required public  init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let keyBytes = try container.decodeIfPresent(Data.self, forKey:.key) {
                self.key = Ed25519PublicKey(bytes: CustomEncoder.convertToInt8Array(input: Array(keyBytes) ))
            }
            
            if let sBytes = try container.decodeIfPresent(Data.self, forKey:.sig){
                self.sig = try Signature(CustomEncoder.convertToInt8Array(input: Array(sBytes) ))
            }
            
           
            
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if let key = self.key{
                try container.encode(Data(CustomEncoder.convertToUInt8Array(input: key.bytes)), forKey: .key)
            }
            if let sig=self.sig?.bytes{
                try container.encode(Data(CustomEncoder.convertToUInt8Array(input: sig)), forKey: .sig)
            }
        }
        
        
        
        
        init(key:[Int8], sig:[Int8]) throws {
            self.key =  Ed25519PublicKey(bytes: key);
            self.sig = try Signature(sig);
        }

        init(key:Ed25519PublicKey, sig:Signature) {
            self.key = key;
            self.sig = sig;
        }

        convenience init(key:Ed25519PublicKey) {
            self.init(key: key,  sig: Signature());
        }

        init() {
            self.key =  Ed25519PublicKey();
            self.sig =  Signature();
        }

    
        public static func ==(lhs:MultisigSubsig,rhs:MultisigSubsig)-> Bool{
            return lhs.sig?.bytes == rhs.sig?.bytes && lhs.key?.bytes==rhs.key?.bytes
        }
        
}
