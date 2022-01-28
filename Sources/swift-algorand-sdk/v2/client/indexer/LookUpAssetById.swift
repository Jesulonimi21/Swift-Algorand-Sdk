//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation


public struct LookUpAssetById: Request {
    public typealias ResponseType = AssetResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: IndexerClient, id: Int64) {
        self.client=client
        parameters = .init(path: "/v2/assets/\(id)")
    }
}
