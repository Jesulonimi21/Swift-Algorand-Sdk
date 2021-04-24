//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/7/21.
//

import Foundation


public class Signature: Codable {
    
    var ED25519_SIG_SIZE = 64;
 
   public var bytes:[Int8]?;

    
    enum CodingKeys:CodingKey{
        case bytes
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let bytes=self.bytes{
            try container.encode(Data(CustomEncoder.convertToUInt8Array(input: bytes)), forKey: .bytes)
        }
      
    }
   
    init(_ rawBytes:[Int8]) throws {
   
            if (rawBytes.count != 64) {
            
                throw  Errors.illegalArgumentError("Given signature length is not \(64)")
            } else {

                self.bytes=rawBytes
            }
        
    }

    init() {
    }

   
    public func getBytes() ->[Int8]{
        return self.bytes!
    }

}
