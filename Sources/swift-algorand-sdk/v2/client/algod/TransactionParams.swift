//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/9/21.
//

import Foundation


public struct TransactionParams: Request {
    public typealias ResponseType = TransactionParametersResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "/v2/transactions/params")
    }
}
