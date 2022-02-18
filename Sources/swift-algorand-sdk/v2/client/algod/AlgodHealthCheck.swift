//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation

public struct AlgodHealthCheck: Request {
    
    public typealias ResponseType = String?
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "/health")
    }
}
