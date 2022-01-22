//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/1/21.
//

import Foundation
public struct DryrunState :Codable, Equatable {

    /**
     * Evaluation error if any
     */
  
    public var error:String?

    /**
     * Line number
     */
 
    public var line:Int64?

    /**
     * Program counter
     */

    public var pc:Int64?


    public var scratch:[TealValue]?

 
    public var stack:[TealValue]?

    
}
