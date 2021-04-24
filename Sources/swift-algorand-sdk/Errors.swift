//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/11/21.
//

import Foundation
public enum Errors:Error,Equatable{
    case runtimeError(String)
    case illegalArgumentError(String)
    case generalSecurityError(String)
    case NetworkError(String)
    
 
//    public static func ==(lhs:Errors,rhs:Errors)-> Bool{
//        return lhs==rhs
//    }
    
}
