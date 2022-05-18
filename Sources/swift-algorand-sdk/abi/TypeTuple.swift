//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 10/05/2022.
//

import Foundation

public struct TypeTuple: ABIType{
    var childTypes: [ABIType]
    
    init(childTypes: [ABIType]) {
        self.childTypes = childTypes
    }
    
    public func isDynamic() -> Bool {
        for i in 0..<self.childTypes.count{
            if(self.childTypes[i].isDynamic() == true){
                return true;
            }
        }
        return false;
    }
    
    
    public func byteLen() throws -> UInt64 {
        var size = 0;
        for var i in 0..<self.childTypes.count{
            if((self.childTypes[i] as? TypeBool) != nil){
                var after = TypeTuple.findBoolLR(typeArray: self.childTypes, var: i, var: 1)
                i = after + i;
                var boolNumber = after + 1;
                size += boolNumber / 8;
                size += (boolNumber % 8 != 0) ? 1: 0;
            }else{
                size += Int( try self.childTypes[i].byteLen())
            }
        }
        return UInt64(size);
    }
   
    
 

}
