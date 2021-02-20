//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/17/21.
//

import Foundation
public class MultisigAddress: Codable {
  
    var version:Int;
 
    var threshold:Int;
    var publicKeys:[Ed25519PublicKey];
    var PREFIX:[Int8]=[77, 117, 108, 116, 105, 115, 105, 103, 65, 100, 100, 114,];

    
    enum CodingKeys:String, CodingKey{
        case version="version"
        case threshold="threshold"
        case publicKeys="publicKeys"
    }
    
    init (version:Int,  threshold:Int,publicKeys:[Ed25519PublicKey]) throws{
        self.version = version;
        self.threshold = threshold;
        self.publicKeys=publicKeys;
        if (self.version != 1) {
            throw  Errors.illegalArgumentError("Unknown msig version");
        } else if (self.threshold == 0 || self.publicKeys.count == 0 || self.threshold > self.publicKeys.count) {
            throw  Errors.illegalArgumentError("Invalid threshold");
        }
    }

 

    private static func toKeys(keys:[[Int8]]) -> [Ed25519PublicKey] {
        var ret = Array(repeating: Ed25519PublicKey(), count: keys.count);
        

        for i in 0..<keys.count{
            ret[i]=Ed25519PublicKey(bytes: keys[i])
        }

        return ret;
    }

    internal func toAddress() throws  ->Address{
        var numPkBytes:Int = 32 * self.publicKeys.count;
        var hashable:[Int8] = Array(repeating: 0, count: PREFIX.count + 2 + numPkBytes)
        for i in 0..<PREFIX.count{
            hashable[i]=PREFIX[i]
        }
        hashable[PREFIX.count] = Int8(self.version);
        hashable[PREFIX.count + 1]  = Int8( self.threshold);

        for i in 0..<self.publicKeys.count{
            var hashablePos=PREFIX.count+2+i*32;
            for j in 0..<32{
                hashable[hashablePos+j]=self.publicKeys[i].getBytes()[j]
            }
        }

        return try! Address(SHA512_256().hash(hashable));
    }

    public func  toString()->String {
      
        return try! self.toAddress().description;
      
    }

  
   

}
