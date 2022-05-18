//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 10/05/2022.
//

import Foundation
public class TypeUFixed: ABIType{
    
    public func isDynamic() -> Bool {
        return false;
    }
    
    var bitSize: UInt64;
    var precision: UInt64;
    
    init(bitSize: UInt64, precision: UInt64) throws{
        if (bitSize < 8 || bitSize > 512 || bitSize % 8 != 0){
            throw Errors.illegalArgumentError(
                                "ufixed initialize failure: bitSize should be in [8, 512] and bitSize mod 8 == 0"
                        );
        }
        if (precision < 1 || precision > 160){
            throw Errors.illegalArgumentError("ufixed initialize failure: precision should be in [1, 160]");
        }
            

        self.bitSize = bitSize
        self.precision = precision
    }
    public func byteLen() throws -> UInt64{
        return self.bitSize / 8;
    }
}
