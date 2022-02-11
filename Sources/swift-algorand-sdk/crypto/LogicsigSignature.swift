//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/6/21.
//

import Foundation
import Ed25519
public class LogicsigSignature:Codable,Equatable {
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
        
            for i in 0..<args.count{

                Uargs.append(Data(CustomEncoder.convertToUInt8Array(input: args[i])))
            }
            
            try container.encode(Uargs, forKey: .args)
        }
        if let logic=self.logic{
            try container.encode(Data(CustomEncoder.convertToUInt8Array(input: logic)), forKey: .logic)
        }
       
        if let sig = self.sig{
            try container.encode(Data(CustomEncoder.convertToUInt8Array(input: sig.bytes ?? [0])), forKey: .sig)
        }
        if let msig = self.msig{
            try container.encode(msig, forKey: .msig)
        }
        

       
     
    }

    enum CodingKeys:String,CodingKey{
        case logic="l"
        case args="arg"
        case sig="sig"
        case msig="msig"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.args = Array()
      
         let Uargs = try? container?.decode([Data].self, forKey: .args)
        if let uargs=Uargs{
            for i in 0..<uargs.count{


               self.args!.append(CustomEncoder.convertToInt8Array(input: Array(Uargs![i])))
            }
        }
        if(self.args?.count==0){
            self.args=nil
        }
        self.logic = try? CustomEncoder.convertToInt8Array(input: Array((container?.decode(Data.self, forKey: .logic))!))
        
        let sigBytes = try? CustomEncoder.convertToInt8Array(input: Array((container?.decode(Data.self, forKey: .sig))!))
        if let sigBytess = (sigBytes){
            self.sig = try? Signature(sigBytess)
        }
        
        self.msig = try? container?.decode(MultisigSignature.self, forKey: .msig)
        
        
      

        
    }
    
    
    public   init(logic:[Int8],args:[[Int8]]?,sig:Signature?,msig:MultisigSignature?) throws {
        self.logic=logic
        self.args=args
        self.sig=sig
        self.msig=msig
                try AlgoLogic.checkProgram(program: logic, args: self.args)
    }
    
    public  convenience init(logicsig:[Int8]) throws {
        try self.init(logicsig: logicsig,args:nil)
    }
    
    public convenience init(logicsig:[Int8],args:[[Int8]]?) throws {
        
        try self.init(logic:logicsig,args:args,sig:nil,msig:nil)
    }
    
   
    public init() {
        self.logic = nil;
        self.args = nil;
    }

    public func toAddress() throws ->Address {
        let prefixedEncoded:[Int8] = self.bytesToSign();
        return  try Address(SHA512_256().hash(prefixedEncoded));
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
    
    public func verify (address:Address) throws ->Bool{
        
        if(self.logic==nil){
            return false
        }else if self.sig != nil && self.msig != nil{
            return false
        }else{
            do{
              try  AlgoLogic.checkProgram(program: self.logic!, args: self.args)
                
            }catch is Error{
                return false
            }
            
            if self.sig == nil && self.msig==nil{
                do{
                    return  try address==self.toAddress()
                    
                }catch is Error{
                    return false
                }
            }else{

                if(self.sig != nil){
            
                    let publicKey = try PublicKey(CustomEncoder.convertToUInt8Array(input: address.getBytes()))
                
                    var isVerified = try publicKey.verify(signature: CustomEncoder.convertToUInt8Array(input: self.sig!.bytes!), message: CustomEncoder.convertToUInt8Array(input: self.bytesToSign()))
                    
                    return isVerified
                }else{
                 
                    return try msig!.verify(message: self.bytesToSign())
                }
             
            }
            
        }
    }
    



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

    
  public  static func ==(lhs: LogicsigSignature, rhs: LogicsigSignature) -> Bool {
        var equal: Bool = false;
        //logic
        equal = lhs.logic==rhs.logic
        if(!equal){
         
            return equal
        }
 
        //args
        equal = lhs.args==rhs.args
        if(!equal){
           
            return equal
        }
  
        //sig
        equal = lhs.sig?.bytes==rhs.sig?.bytes
        if(!equal){
         
            return equal
        }
        //multisig
  
    equal = lhs.msig?.subsigs==rhs.msig?.subsigs&&lhs.msig?.MULTISIG_VERSION==rhs.msig?.MULTISIG_VERSION&&lhs.msig?.threshold==rhs.msig?.threshold&&lhs.msig?.version==rhs.msig?.version
    
        return equal
    
    }
}
