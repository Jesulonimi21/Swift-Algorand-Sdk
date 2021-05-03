//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
public class PendingTransactionsResponse : Codable{
    /**
      * An array of signed transaction objects.
      */
   
    public var topTransactions:[SignedTransaction]?

     /**
      * Total number of transactions in the pool.
      */
   
    public var totalTransactions:Int64?
    
    enum CodingKeys:String,CodingKey{
        case totalTransactions = "total-transactions"
        case topTransactions = "top-transactions"
    }
    
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }

}
