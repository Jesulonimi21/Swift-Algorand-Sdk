//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/10/21.
//

import Foundation
public class PostTransactionsResponse:Codable{
 
    var txId:String;
    
   
    

    init(_ txId : String) {
    self.txId=txId
    }

   
}
