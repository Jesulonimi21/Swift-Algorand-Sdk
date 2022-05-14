//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 10/05/2022.
//

import Foundation
public struct TypeString: ABIType{
    init(){
        
    }
    
    public  func isDynamic() -> Bool{
        return true
    }
    
    public  func byteLen() throws -> UInt64{
        throw Errors.runtimeError("Dynamic type cannot precompute byte length")
    }
}
