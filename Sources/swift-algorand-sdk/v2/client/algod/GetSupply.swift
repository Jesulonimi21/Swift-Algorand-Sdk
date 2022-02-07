//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation


public struct GetSupply: Request {
    public typealias ResponseType = SupplyResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "/v2/ledger/supply")
    }
}
