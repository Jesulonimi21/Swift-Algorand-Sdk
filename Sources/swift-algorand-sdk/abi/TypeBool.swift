//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 10/05/2022.
//

import Foundation

public struct TypeBool: ABIType{
    
    init(){
        
    }
    
    public func isDynamic() -> Bool{
        return false
    }
    
    public func byteLen() throws -> UInt64{
        return 1
    }
    
    
}
