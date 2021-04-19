//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/6/21.
//

import Foundation
public class LogicsigSignature:Codable {
    private static var LOGIC_PREFIX:[Int8]=[80,114,111,103,114,97,109,]
  
    private static  var SIGN_ALGO:String = "EdDSA"

    public var logic:[Int8]?;

    public var args:[[Int8]]?
 
    public var sig:Signature?

    public var msig:MultisigSignature?
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let args = self.args{
            var Uargs:[Data]=Array()
            print(args.count)
            for i in 0..<args.count{

                Uargs.append(Data(CustomEncoder.convertToUInt8Array(input: args[i])))
            }
            
            try! container.encode(Uargs, forKey: .args)
        }
        if let logic=self.logic{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: logic)), forKey: .logic)
        }
       
        if let sig = self.sig{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: sig.bytes!)), forKey: .sig)
        }
//                if let args = self.args{
//                    var Uargs:[String]=Array()
//                    print(args.count)
//                    for i in 0..<args.count{
//
//                        Uargs.append(CustomEncoder.encodeToBase64(args[i]))
//                    }
//                    try! container.encode(Uargs, forKey: .args)
//                }
       
     
    }

    enum CodingKeys:String,CodingKey{
        case logic="l"
        case args="arg"
        case sig="sig"
        case msig="msig"
    }
    
    
    public   init(logic:[Int8],args:[[Int8]]?,sig:Signature?,msig:MultisigSignature?) {
        self.logic=logic
        self.args=args
        self.sig=sig
        self.msig=msig
        
                try! AlgoLogic.checkProgram(program: logic, args: self.args)
    }
    
    public  convenience init(logicsig:[Int8]) {
        self.init(logicsig: logicsig,args:nil)
    }
    
    public convenience init(logicsig:[Int8],args:[[Int8]]?) {
        self.init(logic:logicsig,args:args,sig:nil,msig:nil)
    }
    
   
     init() {
        self.logic = nil;
        self.args = nil;
    }

    public func toAddress() throws ->Address {
        var prefixedEncoded:[Int8] = self.bytesToSign();
        return  try! Address(SHA512_256().hash(prefixedEncoded));
    }

    public func bytesToSign()->[Int8] {
        var prefixedEncoded:[Int8]=Array(repeating: 0, count: self.logic!.count+LogicsigSignature.LOGIC_PREFIX.count)
        
        for i in 0..<LogicsigSignature.LOGIC_PREFIX.count{
            prefixedEncoded[i]=LogicsigSignature.LOGIC_PREFIX[i]
        }

      var counter=0;
            for i in LogicsigSignature.LOGIC_PREFIX.count..<prefixedEncoded.count{
                prefixedEncoded[i]=self.logic![counter]
            counter=counter+1
        }
        return prefixedEncoded;
    }

//    public boolean verify(Address address) {
//        if (this.logic == null) {
//            return false;
//        } else if (this.sig != null && this.msig != null) {
//            return false;
//        } else {
//            try {
//                Logic.checkProgram(this.logic, this.args);
//            } catch (Exception var7) {
//                return false;
//            }
//
//            if (this.sig == null && this.msig == null) {
//                try {
//                    return address.equals(this.toAddress());
//                } catch (NoSuchAlgorithmException var4) {
//                    return false;
//                }
//            } else {
//                PublicKey pk;
//                try {
//                    pk = address.toVerifyKey();
//                } catch (Exception var6) {
//                    return false;
//                }
//
//                if (this.sig != null) {
//                    try {
//                        java.security.Signature sig = java.security.Signature.getInstance("EdDSA");
//                        sig.initVerify(pk);
//                        sig.update(this.bytesToSign());
//                        return sig.verify(this.sig.getBytes());
//                    } catch (Exception var5) {
//                        return false;
//                    }
//                } else {
//                    return this.msig.verify(this.bytesToSign());
//                }
//            }
//        }
//    }
//
//    private static boolean nullCheck(Object o1, Object o2) {
//        if (o1 == null && o2 == null) {
//            return true;
//        } else if (o1 == null && o2 != null) {
//            return false;
//        } else {
//            return o1 == null || o2 != null;
//        }
//    }
//
//    public boolean equals(Object obj) {
//        if (obj instanceof LogicsigSignature) {
//            LogicsigSignature actual = (LogicsigSignature)obj;
//            if (!nullCheck(this.logic, actual.logic)) {
//                return false;
//            } else if (!Arrays.equals(this.logic, actual.logic)) {
//                return false;
//            } else if (!nullCheck(this.args, actual.args)) {
//                return false;
//            } else {
//                if (this.args != null) {
//                    if (this.args.size() != actual.args.size()) {
//                        return false;
//                    }
//
//                    for(int i = 0; i < this.args.size(); ++i) {
//                        if (!Arrays.equals((byte[])this.args.get(i), (byte[])actual.args.get(i))) {
//                            return false;
//                        }
//                    }
//                }
//
//                if (!nullCheck(this.sig, actual.sig)) {
//                    return false;
//                } else if (this.sig != null && !this.sig.equals(actual.sig)) {
//                    return false;
//                } else if (!nullCheck(this.msig, actual.msig)) {
//                    return false;
//                } else {
//                    return this.msig == null || this.msig.equals(actual.msig);
//                }
//            }
//        } else {
//            return false;
//        }
//    }
//
//
}
