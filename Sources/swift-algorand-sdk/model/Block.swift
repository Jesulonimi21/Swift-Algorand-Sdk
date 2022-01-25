//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public struct Block: Codable, Equatable {
    
    public var genesisHash: [Int8]?
    public var genesisId: String?
    public var previousBlockHash: [Int8]?
    public var rewards: BlockRewards?
    public var round: Int64?
    public var seed: [Int8]?
    public var timestamp: Int64?
    public var transactions: [TransactionData]?
    public var transactionsRoot: [Int8]?
    public var txnCounter: Int64?
    public var upgradeState: BlockUpgradeState?
    public var upgradeVote: BlockUpgradeVote?
    
    enum CodingKeys: String, CodingKey {
    case genesisHash  = "genesis-hash"
    case genesisId  = "genesis-id"
    case previousBlockHash = "previous-block-hash"
    case rewards = "rewards"
    case  round = "round"
    case seed = "seed"
    case timestamp  = "timestamp"
    case transactions  = "transactions"
    case  transactionsRoot = "transactions-root"
    case txnCounter = "txn-counter"
    case upgradeState = "upgrade-state"
    case upgradeVote = "upgrade-vote"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let genHashString = try? container.decode(String.self, forKey: .genesisHash) {
        self.genesisHash=CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: genHashString))
        }
        self.genesisId = try? container.decode(String.self, forKey: .genesisId)
        if let previousBlockHashString = try? container.decode(String.self, forKey: .previousBlockHash) {
        self.previousBlockHash=CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: previousBlockHashString))
        }
        self.rewards = try? container.decode(BlockRewards.self, forKey: .rewards)
        self.round = try? container.decode(Int64.self, forKey: .round)
     
        if let seedString = try? container.decode(String.self, forKey: .seed) {
        self.seed=CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: seedString))
        }
        
        self.timestamp = try? container.decode(Int64.self, forKey: .timestamp)
        
        self.transactions = try? container.decode([TransactionData].self, forKey: .transactions)
        
        if let transactionRootString = try? container.decode(String.self, forKey: .transactionsRoot) {
        self.transactionsRoot=CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: transactionRootString))
        }
        
        self.txnCounter = try? container.decode(Int64.self, forKey: .txnCounter)
        
        self.upgradeState =  try? container.decode(BlockUpgradeState.self, forKey: .upgradeState)
        
        self.upgradeVote = try? container.decode(BlockUpgradeVote.self, forKey: .upgradeVote)
    }
    
    public func toJson() -> String? {
        let jsonencoder=JSONEncoder()
        let classData=try? jsonencoder.encode(self)
        let classString=String(data: classData ?? Data(), encoding: .utf8)
       return classString
    }
    
    init(genesisHash: [Int8]? = nil,
                  genesisId: String? = nil,
                  previousBlockHash: [Int8]? = nil,
                  rewards: BlockRewards? = nil,
                  round: Int64? = nil,
                  seed: [Int8]? = nil,
                  timestamp: Int64? = nil,
                  transactions: [TransactionData]? = nil,
                  transactionsRoot: [Int8]? = nil,
                  txnCounter: Int64? = nil,
                  upgradeState: BlockUpgradeState? = nil,
                  upgradeVote: BlockUpgradeVote? = nil) {
        self.genesisHash = genesisHash
        self.genesisId = genesisId
        self.previousBlockHash = previousBlockHash
        self.rewards = rewards
        self.round = round
        self.seed = seed
        self.timestamp = timestamp
        self.transactions = transactions
        self.transactionsRoot = transactionsRoot
        self.txnCounter = txnCounter
        self.upgradeState = upgradeState
        self.upgradeVote = upgradeVote
    }
}
