//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation


public struct LookUpAccountTransactions: Request {
    public typealias ResponseType = TransactionsResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    init(client: IndexerClient, address: String) {
        self.client=client
        parameters = .init(path: "/v2/accounts/\(address)/transactions")
    }
}
