//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/4/21.
//

import Foundation
public class Digest: Codable {
    var  DIG_LEN_BYTES = 32;
var bytes:[Int8]?=nil;

  
    public init(_ bytes:[Int8]?) {
        self.bytes = Array(repeating: 0, count: 32);
        if  let uBytes = bytes{
            if (uBytes.count != 32) {
//                throw new IllegalArgumentException("digest wrong length");
                print("digest wrong length")
            } else {
                self.bytes=uBytes
            }
        }
    }

 
   convenience init(base32StringDigest:String) {
        self.init(CustomEncoder.decodeFromBase32StripPad(base32StringDigest));
    }

   init() {
        self.bytes = Array(repeating: 0, count: 32)
    }

   
    public func getBytes() -> [Int8]?{
        return self.bytes;
    }


    private enum CodingKeys:CodingKey{
        case bytes
    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try! container.encode( Data(CustomEncoder.convertToUInt8Array(input:self.bytes!)), forKey: .bytes)
//    }
}
