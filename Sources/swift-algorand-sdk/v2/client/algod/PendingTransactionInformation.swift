//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation


public struct PendingTransactionInformation: Request {
  
    public typealias ResponseType = PendingTransactionResponse
    
    public let client: HTTPClient
    
    public let parameters: RequestParameters

    init(client: AlgodClient, txId: String) {
        self.client = client
        self.parameters = .init(path: "/v2/transactions/pending/\(txId)")
    }
}
