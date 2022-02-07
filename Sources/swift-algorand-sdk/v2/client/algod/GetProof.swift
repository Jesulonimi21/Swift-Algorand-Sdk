//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation


public class GetProof: Request {
    public typealias ResponseType = ProofResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, round: Int64, txId: String) {
        self.client=client
        parameters = .init(path: "/v2/blocks/\(round)/transactions/\(txId)/proof",
                           queryParameters: ["format": "msgpack"])
    }
}

