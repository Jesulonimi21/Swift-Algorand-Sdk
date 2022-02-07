//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation


public struct WaitForBlock: Request {
    public typealias ResponseType = NodeStatusResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, round: Int64) {
        self.client=client
        parameters = .init(path: "/v2/status/wait-for-block-after/\(round)")
        
    }
    
}
