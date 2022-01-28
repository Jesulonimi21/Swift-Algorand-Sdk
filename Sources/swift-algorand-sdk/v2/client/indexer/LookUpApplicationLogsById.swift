//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 19/01/2022.
//

import Foundation


public class LookUpApplicationLogsById: Request {
    public typealias ResponseType = ApplicationLogResponse
    
    public let client: HTTPClient
    
    public private(set) var parameters: RequestParameters
    
    private var queryItems: [String: String] = [:] {
        didSet { parameters.queryParameters = queryItems }
    }
    
    init(client: IndexerClient,
         applicationId: Int64,
         limit: Int64? = nil,
         maxRound: Int64? = nil,
         minRound: Int64? = nil,
         next: String? = nil,
         senderAddress: Address? = nil,
         txid: String? = nil ) {
        self.client = client
        
        parameters = .init(path: "/v2/applications/\(applicationId)/logs")
        let query: [String: CustomStringConvertible?] = [
            "limit": limit,
            "maxRound": maxRound,
            "minRound": minRound,
            "next": next,
            "senderAddress": senderAddress?.description,
            "txid": txid
        ]
        self.queryItems = query.compactMapValues { $0?.description }
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func limit(limit: Int64) -> LookUpApplicationLogsById {
        self.queryItems["limit"] = "\(limit)"
        return self
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func maxRound(maxRound: Int64) -> LookUpApplicationLogsById {
        self.queryItems["maxRound"] = "\(maxRound)"
        return self
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func minRound(minRound: Int64) -> LookUpApplicationLogsById {
        self.queryItems["minRound"] = "\(minRound)"
        return self
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func next(next: String) -> LookUpApplicationLogsById {
        self.queryItems["next"] = next
        return self
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func senderAddress(senderAddress: Address) -> LookUpApplicationLogsById {
        self.queryItems["senderAddress"] = senderAddress.description
        return self
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func txid(txid: String) -> LookUpApplicationLogsById {
        self.queryItems["txid"] = txid
        return self
    }
    
    // TODO: IMPLEMENT OTHER ways to query including limit and the likes
}
