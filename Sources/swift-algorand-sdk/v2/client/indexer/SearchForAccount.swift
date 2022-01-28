//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation


public class SearchForAccounts: Request {
    public typealias ResponseType = AccountsResponse
    public let client: HTTPClient
    public private(set) var parameters: RequestParameters
    
    private var queryItems: [String: String] = [:] {
        didSet { parameters.queryParameters = queryItems }
    }
    
    init(client: IndexerClient,
         applicationId: Int64? = nil,
         assetId: Int64? = nil,
         authAddr: Address? = nil,
         currencyGreaterThan: Int64? = nil,
         currencyLessThan: Int64? = nil,
         limit: Int64? = nil,
         next: String? = nil,
         round: Int64? = nil) {
        self.client = client
        parameters = .init(path: "/v2/accounts")
        let query: [String: CustomStringConvertible?] = ["application-id": applicationId,
                                                        "asset-id": assetId,
                                                         "auth-addr": authAddr?.description,
                                                        "currency-greater-than": currencyGreaterThan,
                                                        "currency-less-than": currencyLessThan,
                                                        "limit": limit,
                                                        "next": next,
                                                        "round": round
            ]
        
        queryItems = query.compactMapValues { $0?.description }
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func applicationId(applicationId: Int64) -> SearchForAccounts {
           self.queryItems["application-id"] = "\(applicationId)"
           return self
       }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func assetId(assetId: Int64) -> SearchForAccounts {
           self.queryItems["asset-id"]="\(assetId)"
           return self
       }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func authAddr(authAddr: Address) -> SearchForAccounts {
        self.queryItems["auth-addr"]="\(authAddr.description)"
           return self
       }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func currencyGreaterThan(currencyGreaterThan: Int64) -> SearchForAccounts {
           self.queryItems["currency-greater-than"]="\(currencyGreaterThan)"
           return self
       }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func currencyLessThan(currencyLessThan: Int64) -> SearchForAccounts {
           self.queryItems["currency-less-than"]="\(currencyLessThan)"
           return self
       }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func limit(limit: Int64) -> SearchForAccounts {
           self.queryItems["limit"]="\(limit)"
           return self
       }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func next(next: String) -> SearchForAccounts {
           self.queryItems["next"] = next
           return self
       }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func round(round: Int64) -> SearchForAccounts {
           self.queryItems["round"]="\(round)"
           return self
       }
}
