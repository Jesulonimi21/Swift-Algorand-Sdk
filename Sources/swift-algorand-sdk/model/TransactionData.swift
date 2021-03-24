//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation

public class TransactionData:Codable{

public var applicationTransaction:TransactionApplication?
   
public var assetConfigTransaction:TransactionAssetConfig?

public var assetFreezeTransaction:TransactionAssetFreeze?

public var assetTransferTransaction:TransactionAssetTranser?
public var authAddr:String?

public var closeRewards:Int64?

public var closingAmount:Int64?

public var confirmedRound:Int64?

public var createdApplicationIndex:Int64?

public var createdAssetIndex:Int64?

public var fee:Int64?

public var firstValid:Int64?
public var genesisHash:String?

public var genesisId:String?

public var globalStateDelta:[EvalDeltaKeyValue]?
public var group:String?

public var id:String?

public var intraRoundOffset:Int64?

//public var keyregTransaction:TransactionKeyreg?
   
public var lastValid:Int64?
public var lease:String?

public  var localStateDelta:[AccountStateDelta]?
public var note:String?
 
//public var paymentTransaction:TransactionPayment?

public var receiverRewards:Int64?
public var rekeyTo:String?

public var roundTime:Int64?
public var sender:String?
 
public var senderRewards:Int64?

public var signature:TransactionSignature?

public var txType:TxType?
    
    enum CodingKeys:String,CodingKey{
        case txType="tx-type"
        case signature="signature"
        case senderRewards="sender-rewards"
        case sender="sender"
        case roundTime="round-time"
        case rekeyTo="rekey-to"
        case receiverRewards="receiver-rewards"
//        case paymentTransaction="payment-transaction"
        case note="note"
        case localStateDelta="local-state-delta"
        case lease="lease"
        case lastValid="last-valid"
//        case keyregTransaction="keyreg-transaction"
        case intraRoundOffset="intra-round-offset"
        case id="id"
        case group="group"
        case globalStateDelta="global-state-delta"
        case genesisId="genesis-id"
        case genesisHash="genesis-hash"
        case firstValid="first-valid"
        case fee="fee"
        case createdAssetIndex="created-asset-index"
        case createdApplicationIndex="created-application-index"
        case confirmedRound="confirmed-round"
        case closingAmount="closing-amount"
        case closeRewards="close-rewards"
        case authAddr="auth-addr"
        case assetTransferTransaction="asset-transfer-transaction"
        case applicationTransaction="application-transaction"
        case assetConfigTransaction="asset-config-transaction"
        case assetFreezeTransaction="asset-freeze-transaction"
        
    }
//
//    public required init(from decoder: Decoder) throws {
//        var container = try! decoder.container(keyedBy: CodinngKeys.self)
//        self.confirmedRound =  try! container.decode(Int64.self, forKey: .confirmedRound)
//     }
    
}

