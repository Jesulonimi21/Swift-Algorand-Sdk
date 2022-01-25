//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//
import Foundation
import Alamofire

public class LookUpAssetBalances: Request {
    public typealias ResponseType = AssetBalancesResponse
    public let client: HTTPClient
    public private(set) var parameters: RequestParameters
    
    private var queryItems: [String: String] = [:] {
        didSet { parameters.queryParameters = queryItems }
    }
    
    init(client: IndexerClient,
         assetId: Int64,
         currencyGreaterThan: Int64? = nil,
         currencyLessThan: Int64? = nil,
         limit: Int64? = nil,
         round: Int64? = nil,
         next: String? = nil ) {
        self.client = client
        
        let query: [String: CustomStringConvertible?] =
        [
            "currency-greater-than": currencyGreaterThan,
            "currency-less-than": currencyLessThan,
            "limit": limit,
            "round": round,
            "next": next
        ]
        
        parameters = .init(path: "/v2/assets/\(assetId)/balances")
        
        queryItems = query.compactMapValues { $0?.description }
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func currencyGreaterThan(currencyGreaterThan:Int64)->LookUpAssetBalances {
        self.queryItems["currency-greater-than"]="\(currencyGreaterThan)"
        return self;
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func currencyLessThan(currencyLessThan:Int64) ->LookUpAssetBalances{
        self.queryItems["currency-less-than"]="\(currencyLessThan)"
        return self;
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func limit(limit:Int64)->LookUpAssetBalances {
        self.queryItems["limit"]="\(limit)"
        return self;
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func name(round:Int64)->LookUpAssetBalances {
        self.queryItems["round"]="\(round)"
        return self;
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func next(next:String)->LookUpAssetBalances {
        self.queryItems["next"]="\(next)"
        return self;
    }
}

