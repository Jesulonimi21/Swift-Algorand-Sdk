//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/18/21.
//

import Foundation
public class MultisigSignature : Codable {
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

    init(version:Int, threshold:Int,  subsigs:[MultisigSubsig]?) {
        self.subsigs = subsigs;
        self.threshold = threshold
        self.version = version;
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try!container.encode(subsigs, forKey: .subsigs)
        try!container.encode(threshold, forKey: .threshold)
        try!container.encode(version, forKey: .version)
    }

    convenience init(version:Int, threshold:Int) {
        self.init(version: version, threshold: threshold, subsigs: [MultisigSubsig]());
    }

    init() {
        self.subsigs=[MultisigSubsig]();
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

    }

   
    public  class MultisigSubsig :Codable{
 
        var key:Ed25519PublicKey?;

        var sig:Signature?;

        enum CodingKeys:String,CodingKey{
            case key="pk"
            case sig="s"
        }
        required public  init(from decoder: Decoder) throws {
            var container = try! decoder.container(keyedBy: CodingKeys.self)
            
            var keyBytes =  try? container.decode(Data.self, forKey:.key)
            if let kb = keyBytes{
                self.key = Ed25519PublicKey(bytes: CustomEncoder.convertToInt8Array(input: Array(kb) ))
            }
            
            var sBytes = try? container.decode(Data.self, forKey:.sig)
            if let sB = sBytes{
                self.sig = try! Signature(CustomEncoder.convertToInt8Array(input: Array(sB) ))
            }
            
           
            
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if let key = self.key{
                try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: key.bytes)), forKey: .key)
            }
            if let sig=self.sig?.bytes{
                try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: sig)), forKey: .sig)
            }
        }
        
        
        
        
        init(key:[Int8]?, sig:[Int8]?) {
            self.key =  Ed25519PublicKey(bytes: key!);
            self.sig = try! Signature(sig!);
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

    
    
}
