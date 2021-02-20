//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation
public class PendingTransactionResponse : Codable {

    var  applicationIndex:Int64?;
    var assetIndex:Int64?;
   
    var closeRewards:Int64?

    var closingAmount:Int64?
  
    var confirmedRound:Int64?
 
   var globalStateDelta:[EvalDeltaKeyValue]?;
   
   var localStateDelta:[AccountStateDelta]?

    var poolError:String?;
   
    var receiverRewards:Int64?;
  
    var senderRewards:Int64?;
    
//    var txn:SignedTransaction?;

   init() {
    }

    enum CodingKeys:String,CodingKey {
    
        case  applicationIndex="application-index";
  
        case assetIndex="asset-index";
     
        case closeRewards="close-rewards"

        case closingAmount="closing-amount"

        case confirmedRound="confirmed-round"
        
       case globalStateDelta="global-state-delta"
       
       case localStateDelta="local-state-delta"
    
        case poolError="pool-error"
      
        case receiverRewards="receiver-rewards"

        case senderRewards="sender-rewards"
 
//        case txn="txn"
    }
  
}
