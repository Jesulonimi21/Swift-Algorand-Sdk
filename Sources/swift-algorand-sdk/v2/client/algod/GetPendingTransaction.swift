//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation


public class GetPendingTransactions: Request {
    
    public typealias ResponseType = PendingTransactionResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        self.parameters = .init(path: "/v2/transactions/pending",
                                queryParameters: ["max": "0"])
    }
}
