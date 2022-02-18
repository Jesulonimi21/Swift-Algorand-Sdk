//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/15/21.
//

import Foundation


public struct GetBlock: Request {
    public typealias ResponseType = BlockResponse
    
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, round: Int64) {
        self.client=client
        parameters = .init(path: "/v2/blocks/\(round)")
    }
}
