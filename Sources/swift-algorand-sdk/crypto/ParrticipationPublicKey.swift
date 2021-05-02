//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/6/21.
//

import Foundation
public class ParticipationPublicKey: Codable,Equatable {
   var KEY_LEN_BYTES = 32;
    var bytes:[Int8] = Array(repeating: 0, count: 32);

    enum CodingKeys:String, CodingKey{
        case bytes
    }
    init(bytes:[Int8])throws {
     
        if (bytes.count != 32) {

           throw  Errors.illegalArgumentError("participation key wrong length")
           
            } else {
                self.bytes=bytes
            }
 
    }

    init() {
    }


    public func getBytes() -> [Int8]{
        return self.bytes;
    }
    
    public static func == (lhs:ParticipationPublicKey,rhs:ParticipationPublicKey)->Bool{
        return lhs.bytes == rhs.bytes
    }

}

