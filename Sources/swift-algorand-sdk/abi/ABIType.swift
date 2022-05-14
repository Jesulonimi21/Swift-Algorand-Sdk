//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 14/05/2022.
//

import Foundation
public protocol ABIType{
    var ABI_DYNAMIC_HEAD_BYTE_LEN: UInt64{get set}
    
    func isDynamic() -> Bool
    
    func byteLen() throws -> UInt64
}

extension ABIType{
    public var ABI_DYNAMIC_HEAD_BYTE_LEN: UInt64 {
        set{
            ABI_DYNAMIC_HEAD_BYTE_LEN = 2
        }
        get{
            return 2
        }
    }
//     var staticArrayPattern = "^(?<elemT>[a-z\\d\\[\\](),]+)\\[(?<len>[1-9][\\d]*)]$"
//     var ufixedPattern = "^ufixed(?<size>[1-9][\\d]*)x(?<precision>[1-9][\\d]*)$"
    
}
