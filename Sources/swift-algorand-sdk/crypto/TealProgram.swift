//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/8/21.
//

import Foundation

public class TEALProgram {
    private var program:[Int8]?


    // default values for serializer to ignore
    public init() {
    }

    /**
     * Initialize a TEALProgram based on the byte array. A runtime exception is thrown if the program is invalid.
     * @param program
     */
    
    public init (program:[Int8]) throws{
      try  AlgoLogic.readProgram(program: program, args: nil)
        self.program = program
    }


    /**
     * Initialize a TEALProgram based on the base64 encoding. A runtime exception is thrown if the program is invalid.
     * @param base64String
     */
    public convenience init(base64String:String) throws{
    try    self.init(program:CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: base64String)));
    }
}
