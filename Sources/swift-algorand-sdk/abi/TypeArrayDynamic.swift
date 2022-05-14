//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 14/05/2022.
//

import Foundation
public struct TypeArrayDynamic: ABIType{
 
    
    public var elemType: ABIType
    
    
    init(elemType: ABIType, length: UInt64) throws {
        self.elemType = elemType
 
    }
   
    public  func isDynamic() -> Bool{
        return true;
    }
    
    public  func byteLen() throws -> UInt64{
        throw Errors.illegalArgumentError("Dynamic type cannot pre-compute byteLen")
        }
    
}

