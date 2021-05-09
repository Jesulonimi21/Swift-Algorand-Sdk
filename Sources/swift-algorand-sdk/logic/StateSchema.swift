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

    enum CodingKeys:String,CodingKey{
        case numUint = "nui"
        case numByteSlice="nbs"
    }

  public  init() {
        self.numUint = 0;
      self.numByteSlice = 0;
    }

   public init(_ numUint:Int64, _ numByteSlice:Int64) {
        self.numUint = 0;
        self.numByteSlice = 0;
        self.numUint = numUint;
        self.numByteSlice = numByteSlice;
    }

 public convenience init( numUint:Int64,  numByteSlice:Int64) {
        self.init(numUint,numByteSlice);
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
       
        if(numByteSlice != 0){
        try    container.encode(numByteSlice, forKey: .numByteSlice)
        }
        if(numUint != 0){
          try  container.encode(numUint, forKey: .numUint)
        }
       
    }

  
}
