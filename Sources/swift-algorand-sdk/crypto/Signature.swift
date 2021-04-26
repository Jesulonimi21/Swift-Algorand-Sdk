//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/7/21.
//

import Foundation


public class Signature: Codable,Equatable {
    
    var ED25519_SIG_SIZE = 64;
 
   public var bytes:[Int8]?;

    
    enum CodingKeys:CodingKey{
        case bytes
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let bytes=self.bytes{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: bytes)), forKey: .bytes)
        }
      
    }
    
    public required init(from decoder: Decoder) throws {
        var container = try decoder.singleValueContainer()
        var bytesData = try? container.decode(Data.self)
        if let _ = bytesData{
            self.bytes = CustomEncoder.convertToInt8Array(input: Array(bytesData!))
        }
        
    }
   
   public init(_ rawBytes:[Int8]) throws {
   
            if (rawBytes.count != 64) {
            
                throw  Errors.illegalArgumentError("Given signature length is not \(64)")
            } else {

                self.bytes=rawBytes
            }
        
    }

   public init() {
    }

   
    public func getBytes() ->[Int8]{
        return self.bytes!
    }
    public static func == (lhs:Signature,rhs:Signature)->Bool{
        return lhs.bytes==rhs.bytes
    }
   
}
