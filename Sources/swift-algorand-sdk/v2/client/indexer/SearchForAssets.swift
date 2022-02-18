//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

// extension URLComponents {
//
//    mutating func setQueryItems(with parameters: [String: String]) {
//        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//    }
// }

import Foundation


public class SearchForAssets: Request {
    public typealias ResponseType = AssetsResponse
    public let client: HTTPClient
    public var parameters: RequestParameters
    
    private var queryItems: [String: String] = [:] {
        didSet { parameters.queryParameters = queryItems }
    }
    
    init(client: IndexerClient,
         assetId: Int64? = nil,
         creator: String? = nil,
         limit: Int64? = nil,
         name: String? = nil,
         next: String? = nil,
         unit: String? = nil ) {
        self.client = client
        parameters = .init(path: "/v2/assets")
        let query: [String: CustomStringConvertible?]
        query = [
            "asset-id": assetId,
            "creator": creator,
            "limit": limit,
            "name": name,
            "next": next,
            "unit": unit
        ]
        
        self.queryItems = query.compactMapValues { $0?.description }
        
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func assetId(assetId: Int64) -> SearchForAssets {
        self.queryItems["assetId"]="\(assetId)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func creator(creator: String) -> SearchForAssets {
        self.queryItems["creator"]="\(creator)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func limit(limit: Int64) -> SearchForAssets {
        self.queryItems["limit"]="\(limit)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func name(name: String) -> SearchForAssets {
        self.queryItems["name"]="\(name)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func next(next: String) -> SearchForAssets {
        self.queryItems["next"]="\(next)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func unit(unit: String) -> SearchForAssets {
        self.queryItems["unit"]="\(unit)"
        return self
    }
}
