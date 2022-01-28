//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation


public class MakeHealthCheck: Request {
    public typealias ResponseType = HealthCheck
    public let client: HTTPClient
    public let parameters: RequestParameters
    init(client: IndexerClient) {
        self.client=client
        parameters = .init(path: "/health")
    }
}
