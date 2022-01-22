//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation
public struct PendingTransactionResponse : Codable, Equatable {

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
    
    var innerTxns: [PendingTransactionResponse]?
    
    var logs: [[Int8]]?

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
        
        case innerTxns = "inner-txns"
        
        case logs = "logs"
    }
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = try? encoder.container(keyedBy: CodingKeys.self)
        try container?.encode(self.applicationIndex, forKey: .applicationIndex)
        try container?.encode(self.assetIndex, forKey: .assetIndex)
        try container?.encode(self.closeRewards, forKey: .closeRewards)
        try container?.encode(self.closingAmount, forKey: .closingAmount)
        try container?.encode(self.confirmedRound, forKey: .confirmedRound)
        try container?.encode(self.globalStateDelta, forKey: .globalStateDelta)
        try container?.encode(self.localStateDelta, forKey: .localStateDelta)
        try container?.encode(self.poolError, forKey: .poolError)
        try container?.encode(self.receiverRewards, forKey: .receiverRewards)
        try container?.encode(self.txn, forKey: .txn)
        try container?.encode(self.innerTxns, forKey: .innerTxns)
        
        let logs = logs?.map {
            Data(CustomEncoder.convertToUInt8Array(input: $0))
        }
        try container?.encode(logs, forKey: .logs)
        
    }
    
    
    
    public init(from decoder: Decoder) throws {
        var container = try? decoder.container(keyedBy: CodingKeys.self)
        self.applicationIndex = try? container?.decode(Int64.self, forKey: .applicationIndex)
        self.assetIndex = try? container?.decode(Int64.self, forKey: .assetIndex)
        self.closeRewards = try? container?.decode(Int64.self, forKey: .closeRewards)
        self.closingAmount = try? container?.decode(Int64.self, forKey: .closingAmount)
        self.confirmedRound = try? container?.decode(Int64.self, forKey: .confirmedRound)
        self.globalStateDelta = try? container?.decode([EvalDeltaKeyValue].self, forKey: .globalStateDelta)
        self.localStateDelta = try? container?.decode([AccountStateDelta].self, forKey: .localStateDelta)
        self.poolError = try? container?.decode(String.self, forKey: .poolError)
        self.receiverRewards = try? container?.decode(Int64.self, forKey: .receiverRewards)
        self.senderRewards = try? container?.decode(Int64.self, forKey: .senderRewards)
        self.innerTxns = try? container?.decode([PendingTransactionResponse].self, forKey: .innerTxns)
        self.txn = try? container?.decode(SignedTransaction.self, forKey: .txn)
        
        
        
         let ULogs = try? container?.decode([Data].self, forKey: .logs)
        if let uLogs=ULogs{
            self.logs = Array()
            for i in 0..<uLogs.count{
               self.logs?.append(CustomEncoder.convertToInt8Array(input: Array(ULogs![i])))
            }
        }

    }

  
}
