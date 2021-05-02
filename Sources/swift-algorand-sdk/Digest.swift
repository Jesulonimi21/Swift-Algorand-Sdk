//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/4/21.
//

import Foundation
public class Digest: NSObject, Codable {
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

    public override init() {
        self.bytes = nil
    }

   
    public func getBytes() -> [Int8]?{
        return self.bytes;
    }


    private enum CodingKeys:CodingKey{
        case bytes
    }
    
//    public static func == (lhs:Digest,rhs:Digest)->Bool{
//        print("lhs hash : \(lhs.bytes) rhs : \(rhs.bytes)")
//        return lhs.bytes == rhs.bytes
//    }
    
    public override func isEqual(_ object:   (Any)?) -> Bool {
            if let other = object as? Digest {
                return self.bytes == other.bytes
            } else {
                return false
            }
        }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try! container.encode( Data(CustomEncoder.convertToUInt8Array(input:self.bytes!)), forKey: .bytes)
//    }
  
}
