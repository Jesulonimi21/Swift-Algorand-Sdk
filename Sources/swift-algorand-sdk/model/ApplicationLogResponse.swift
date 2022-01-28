//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 19/01/2022.
//

import Foundation

public struct ApplicationLogResponse: Codable, Equatable {
    var applicationId: Int64?
    var currentRound: Int64?
    var logData: [ApplicationLogData]?
    var nextToken: String?
    
    enum CodingKeys: String, CodingKey {
        case applicationId="application-id"
        case currentRound="current-round"
        case logData="log-data"
        case nextToken = "next-token"
    }
    
    public func toJson() -> String? {
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
}
