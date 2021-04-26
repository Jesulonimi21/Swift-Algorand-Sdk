//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/17/21.
//

import Foundation
public class Ed25519PublicKey : Codable,Equatable {
    var  KEY_LEN_BYTES = 32;
    public var bytes:[Int8] = Array(repeating: 0, count: 32) ;
    
    enum  CodingKeys:String,CodingKey{
        case bytes="bytes"
    }
 
   public init(bytes:[Int8]) {
        self.bytes=bytes
    }

    init () {
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try! encoder.container(keyedBy: CodingKeys.self)
        try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: self.bytes)), forKey: .bytes)
    }

    public required init(from decoder: Decoder) throws {
        var container = try decoder.singleValueContainer()
        var bytesData = try? container.decode(Data.self)
        if let bData = bytesData {
            self.bytes = CustomEncoder.convertToInt8Array(input: Array(bytesData!))
        }
    }
   
    public func getBytes()->[Int8] {
        return self.bytes;
    }

    public static func == (lhs:Ed25519PublicKey,rhs:Ed25519PublicKey)->Bool{
        return lhs.bytes==rhs.bytes
    }
   
}
