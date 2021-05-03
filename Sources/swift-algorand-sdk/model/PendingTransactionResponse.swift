//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation
public class PendingTransactionResponse : Codable {

    public  var  applicationIndex:Int64?;
    public var assetIndex:Int64?;
   
    public var closeRewards:Int64?

    public   var closingAmount:Int64?
  
    public  var confirmedRound:Int64?
 
    public  var globalStateDelta:[EvalDeltaKeyValue]?;
   
    public  var localStateDelta:[AccountStateDelta]?

    public  var poolError:String?;
   
    public var receiverRewards:Int64?;
  
    public var senderRewards:Int64?;
    
    var txn:SignedTransaction?;

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
 
        case txn="txn"
    }
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }

  
}
