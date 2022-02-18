//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation


public class GetPendingTransactionsByAddress: Request {
    
    public typealias ResponseType = PendingTransactionResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, address: Address) {
        self.client = client
        self.parameters = .init(path: "/v2/accounts/\(address.description)/transactions/pending")
    }
}
