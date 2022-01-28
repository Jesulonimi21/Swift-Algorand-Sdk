//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation


public struct LookupBlock: Request {
    
    public typealias ResponseType = Block
    public let client: HTTPClient
    public var parameters: RequestParameters
    
    init(client: IndexerClient, roundNumber: Int64) {
        self.client = client
        parameters = .init(path: "/v2/blocks/\(roundNumber)")
    }
}
