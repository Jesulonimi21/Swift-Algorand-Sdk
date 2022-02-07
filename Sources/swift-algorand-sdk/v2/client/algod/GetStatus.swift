//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation


public class GetStatus: Request {
    public typealias ResponseType = NodeStatusResponse
    
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "/v2/status/")
    }
}
