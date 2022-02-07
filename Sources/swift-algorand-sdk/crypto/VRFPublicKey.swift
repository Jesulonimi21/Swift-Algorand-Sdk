//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/6/21.
//

import Foundation
public class VRFPublicKey : Codable,Equatable {
   var  KEY_LEN_BYTES = 32
    var bytes:[Int8] = Array(repeating: 0, count: 32)
public
    enum CodingKeys:String, CodingKey{
        case bytes
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Data(CustomEncoder.convertToUInt8Array(input: self.bytes)), forKey: .bytes)
    }
    
    init(bytes:[Int8]) throws {
            if (bytes.count != 32) {
                throw  Errors.illegalArgumentError("vrf key wrong length")

            } else {
                self.bytes=bytes
            }
        
    }

   init() {
    }

    public static func == (lhs:VRFPublicKey,rhs:VRFPublicKey)->Bool{
        return lhs.bytes == rhs.bytes
    }
 
}
