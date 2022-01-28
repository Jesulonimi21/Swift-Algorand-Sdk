//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation


public class LookUpAssetTransactions: Request {
    public typealias ResponseType = TransactionsResponse
    
    public let client: HTTPClient
    public private (set) var parameters: RequestParameters
    
    private var queryItems: [String: String]=[:] {
        didSet {
            self.parameters.queryParameters = queryItems
        }
    }
    
    init(client: IndexerClient,
         assetId: Int64,
         address: Address? = nil,
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
         txid: String? = nil) {
        self.client = client
        parameters = .init(path: "/v2/assets/\(assetId)/balances")
        
        let query: [String: CustomStringConvertible?] =
        [
            "address": address?.description,
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
        self.queryItems = query.compactMapValues { $0?.description }
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func address(address: Address) -> LookUpAssetTransactions {
        self.queryItems["address"] = address.description
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func currencyGreaterThan(currencyGreaterThan: Int64) -> LookUpAssetTransactions {
        self.queryItems["currency-greater-than"] = "\(currencyGreaterThan)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func currencyLessThan( currencyLessThan: Int64) -> LookUpAssetTransactions {
        self.queryItems["currency-less-than"] = "\(currencyLessThan)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func excludeCloseTo(excludeCloseTo: Bool) -> LookUpAssetTransactions {
        self.queryItems["exclude-close-to"] = "\(excludeCloseTo)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func limit(limit: Int64) -> LookUpAssetTransactions {
        self.queryItems["limit"] = "\(limit)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func maxRound(maxRound: Int64) -> LookUpAssetTransactions {
        self.queryItems["max-round"]="\(maxRound)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func minRound(minRound: Int64) -> LookUpAssetTransactions {
        self.queryItems["min-round"] = "\(minRound)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func next(next: String) -> LookUpAssetTransactions {
        self.queryItems["next"] = next
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func notePrefix(notePrefix: Data) -> LookUpAssetTransactions {
        self.queryItems["note-prefix"] = CustomEncoder.encodeToBase64(notePrefix)
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func rekeyTo(rekeyTo: Bool) -> LookUpAssetTransactions {
        self.queryItems["rekey-to"] = "\(rekeyTo)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func round(round: Int64) -> LookUpAssetTransactions {
        self.queryItems["round"] = "\(round)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func txid( txid: String) -> LookUpAssetTransactions {
        self.queryItems["txid"] = txid
        return self
    }
}
