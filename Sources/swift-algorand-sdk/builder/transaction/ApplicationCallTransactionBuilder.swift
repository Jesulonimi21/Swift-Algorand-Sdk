//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/12/21.
//

import Foundation
public class ApplicationCallTransactionBuilder:ApplicationBaseTransactionBuilder<ApplicationCallTransactionBuilder>{
   
    convenience init(){
         self.init(Transaction.type.ApplicationCall)
         self.onCompletion(onCompletion: Transaction.onCompletion.NoOpOC)
     }
}
