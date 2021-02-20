//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/6/21.
//

import Foundation
public class StateSchema: Codable {
   
    var numUint:Int64=0;

    var numByteSlice:Int64=0;

//    enum CodingKeys:String,CodingKey{
//        case numUint = "nui"
//        case numByteSlice="nbs"
//    }

    init() {
        self.numUint = 0;
      self.numByteSlice = 0;
    }

    init(_ numUint:Int64, _ numByteSlice:Int64) {
        self.numUint = 0;
        self.numByteSlice = 0;
        self.numUint = numUint;
        self.numByteSlice = numByteSlice;
    }

  convenience init( numUint:Int64,  numByteSlice:Int64) {
        self.init(numUint,numByteSlice);
    }

  
}
