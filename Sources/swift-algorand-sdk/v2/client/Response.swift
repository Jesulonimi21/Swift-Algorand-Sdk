//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation
public class Response<T>{
        
    init() {
        self.isSuccessful=false
    }
    
  public  var isSuccessful:Bool
   public var data:T?
   public var errorDescription:String?

    func setIsSuccessful(value:Bool){
        self.isSuccessful=value
        self.errorDescription="";
    }
    func setData(data:T){
        self.data=data
    }
    
    func setErrorDescription(errorDescription:String){
        self.errorDescription=errorDescription
    }
    
}
