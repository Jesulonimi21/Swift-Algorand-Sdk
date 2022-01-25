//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 19/01/2022.
//

import Foundation

public struct ApplicationLogData: Codable, Equatable {
    
    var logs: [[Int8]]?
    var txid: String?
    
    enum CodingKeys: String, CodingKey {
        case logs = "logs"
        case txid = "txid"
    }
    
    public init(from decoder: Decoder) throws {
        var container = try? decoder.container(keyedBy: CodingKeys.self)
        self.txid=try? container?.decode(String.self, forKey: .txid)
        var base64Encoded = try? container?.decode([String].self, forKey: .logs)
        if let unWrappedBase64Encoded = base64Encoded {
            self.logs = Array(repeating: [], count: unWrappedBase64Encoded.count)
            for i in 0..<unWrappedBase64Encoded.count {
                self.logs?[i] = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: unWrappedBase64Encoded[i]))
            }
        } else {
            throw Errors.runtimeError("Base64 encoded was null")
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try? encoder.container(keyedBy: CodingKeys.self)
        try? container?.encode(self.txid, forKey: .txid)
        var ret = Array(repeating: "", count: logs?.count ?? 0)
        if let  unWrappedLogs = logs {
            for i in 0..<unWrappedLogs.count {
                ret[i] = CustomEncoder.encodeToBase64(unWrappedLogs[i])
            }
            try? container?.encode(ret, forKey: .logs)
        } else {
            throw Errors.runtimeError("Logs were null")
//            print("Logs were null");
        }
        
    }
}
