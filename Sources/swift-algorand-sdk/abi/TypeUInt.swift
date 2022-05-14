//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 10/05/2022.
//

import Foundation
public struct TypeUInt: ABIType{
    public var bitSize: Int64
    public init(size: Int64) throws {
        if(size < 8 || size > 512 || size % 8 != 0){
            throw Errors.illegalArgumentError("uint initialize failure: bitSize should be in [8, 512] and bitSize mod 8 == 0")
        }
        self.bitSize = size;
    }
    
    
    public func isDynamic() -> Bool{
        return false
    }
    
    public func byteLen() throws -> UInt64{
        return UInt64(self.bitSize/8)
    }
}
