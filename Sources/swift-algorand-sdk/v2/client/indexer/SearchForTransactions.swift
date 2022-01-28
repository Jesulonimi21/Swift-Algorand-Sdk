//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation


public class SearchForTransactions: Request {
    public typealias ResponseType = TransactionsResponse
    public let client: HTTPClient
    private var queryItems: [String: String] = [:] {
        didSet {
            parameters.queryParameters = queryItems
        }
    }
    public private(set) var parameters: RequestParameters
    
    init(client: IndexerClient,
         address: Address? = nil,
         applicationId: Int64? = nil,
         assetId: Int64? = nil,
         currencyGreaterThan: Int64? = nil,
         currencyLessThan: Int64? = nil,
         excludeCloseTo: Bool? = nil,
         limit: Int64? = nil,
         maxRound: Int64? = nil,
         minRound: Int64? = nil,
         next: String? = nil,
         notePrefix: Data? = nil,
         rekeyTo: Bool? = nil,
         round: Int64? = nil,
         txid: String? = nil ) {
        self.client = client
        parameters = .init(path: "/v2/transactions")
        let query: [String: CustomStringConvertible?]
        
        query = [
            "address": address?.description,
            "application-id": applicationId,
            "asset-id": assetId,
            "currency-greater-than": currencyGreaterThan,
            "currency-less-than": currencyLessThan,
            "exclude-close-to": excludeCloseTo,
            "limit": limit,
            "max-round": maxRound,
            "min-round": minRound,
            "next": next,
            "note-prefix": notePrefix,
            "rekey-to": rekeyTo,
            "round": round,
            "txid": txid
        ]
        queryItems = query.compactMapValues { $0?.description }
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func address(address: Address) -> SearchForTransactions {
        self.queryItems["address"] = address.description
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func applicationId(applicationId: Int64) -> SearchForTransactions {
        self.queryItems["application-id"] = "\(applicationId)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func assetId(assetId: Int64) -> SearchForTransactions {
        self.queryItems["asset-id"]="\(assetId)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func currencyGreaterThan(currencyGreaterThan: Int64) -> SearchForTransactions {
        self.queryItems["currency-greater-than"] = "\(currencyGreaterThan)"
        return self
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func currencyLessThan( currencyLessThan: Int64) -> SearchForTransactions {
        self.queryItems["currency-less-than"] = "\(currencyLessThan)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func excludeCloseTo(excludeCloseTo: Bool) -> SearchForTransactions {
        self.queryItems["exclude-close-to"] = "\(excludeCloseTo)"
        return self
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func limit(limit: Int64) -> SearchForTransactions {
        self.queryItems["limit"] = "\(limit)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func maxRound(maxRound: Int64) -> SearchForTransactions {
        self.queryItems["max-round"]="\(maxRound)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func minRound(minRound: Int64) -> SearchForTransactions {
        self.queryItems["min-round"] = "\(minRound)"
        return self
    }
    
    public func next(next: String) -> SearchForTransactions {
        self.queryItems["next"] = next
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func notePrefix(notePrefix: Data) -> SearchForTransactions {
        self.queryItems["note-prefix"] = CustomEncoder.encodeToBase64(notePrefix)
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func rekeyTo(rekeyTo: Bool) -> SearchForTransactions {
        self.queryItems["rekey-to"] = "\(rekeyTo)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func round(round: Int64) -> SearchForTransactions {
        self.queryItems["round"] = "\(round)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func txid( txid: String) -> SearchForTransactions {
        self.queryItems["txid"] = txid
        return self
    }
}
