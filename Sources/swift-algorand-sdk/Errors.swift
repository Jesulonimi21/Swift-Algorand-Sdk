//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/11/21.
//

import Foundation
enum Errors:Error{
    case runtimeError(String)
    case illegalArgumentError(String)
    case generalSecurityError(String)
    case NetworkError(String)
    
}
