//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 10/05/2022.
//

import Foundation
public struct TypeArrayStatic: ABIType{
    public var elemType: ABIType
    public var length: UInt64
    
    
    init(elemType: ABIType, length: UInt64) throws {
        if(length < 1){
            throw Errors.illegalArgumentError("static-array initialize failure: array length should be at least 1")
        }
        self.elemType = elemType
        self.length = length
    }
   
    public  func isDynamic() -> Bool{
        return elemType.isDynamic();
    }
    
    public  func byteLen() throws -> UInt64 {
        if let elemBoolType = elemType as? TypeBool{
            return self.length + 7*8
        }else{
            return try elemType.byteLen() * self.length
        }
    }
}
