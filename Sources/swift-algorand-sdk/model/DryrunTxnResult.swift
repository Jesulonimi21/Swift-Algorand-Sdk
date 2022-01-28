//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/1/21.
//

import Foundation
public struct DryrunTxnResult: Codable, Equatable {
  
    public var  appCallMessages: [String]?

    public var appCallTrace: [DryrunState]?
    
    public var cost: Int64?

    /**
     * Disassembled program line by line.
     */
 
    public var disassembly: [String]?

    /**
     * Application state delta.
     */

    public var globalDelta: [EvalDeltaKeyValue]?

    public var localDeltas: [AccountStateDelta]?

    public var  logicSigMessages: [String]?

    public var  logicSigTrace: [DryrunState]?
    
    public var logs: [[Int8]]?

    enum CodingKeys: String, CodingKey {
        case appCallMessages = "app-call-messages"
        case disassembly = "disassembly"
        case globalDelta = "global-delta"
        case localDeltas = "local-deltas"
        case logicSigMessages = "logic-sig-messages"
        case logicSigTrace = "logic-sig-trace"
        case appCallTrace = "app-call-trace"
        case cost = "cost"
        case logs = "logs"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try? encoder.container(keyedBy: CodingKeys.self)
        try container?.encode(self.appCallMessages, forKey: .appCallMessages)
        try container?.encode(self.disassembly, forKey: .disassembly)
        try container?.encode(self.globalDelta, forKey: .globalDelta)
        try container?.encode(self.localDeltas, forKey: .localDeltas)
        try container?.encode(self.logicSigMessages, forKey: .logicSigMessages)
        try container?.encode(self.logicSigTrace, forKey: .logicSigTrace)
        try container?.encode(self.appCallTrace, forKey: .appCallTrace)
        try container?.encode(self.cost, forKey: .cost)
        
        if let logs = self.logs {
            
            var ULogs: [Data]=Array()

            for i in 0..<logs.count {

                ULogs.append(Data(CustomEncoder.convertToUInt8Array(input: logs[i])))
            }
            
            try container?.encode(ULogs, forKey: .logs)
        }
    }
    
    public init(from decoder: Decoder) throws {
        var container = try? decoder.container(keyedBy: CodingKeys.self)
        self.appCallMessages = try? container?.decode([String].self, forKey: .appCallMessages)
        self.appCallTrace = try? container?.decode([DryrunState].self, forKey: .appCallTrace)
        self.disassembly = try? container?.decode([String].self, forKey: .disassembly)
        self.globalDelta = try? container?.decode([EvalDeltaKeyValue].self, forKey: .globalDelta)
        self.localDeltas = try? container?.decode([AccountStateDelta].self, forKey: .localDeltas)
        self.logicSigMessages = try? container?.decode([String].self, forKey: .logicSigMessages)
        self.logicSigTrace = try? container?.decode([DryrunState].self, forKey: .logicSigTrace)
        self.cost = try? container?.decode(Int64.self, forKey: .cost)
        
        self.logs = Array()
         let ULogs = try? container?.decode([Data].self, forKey: .logs)
        if let uLogs=ULogs {
            for i in 0..<uLogs.count {
               self.logs?.append(CustomEncoder.convertToInt8Array(input: Array(ULogs![i])))
            }
        }
    }

}
