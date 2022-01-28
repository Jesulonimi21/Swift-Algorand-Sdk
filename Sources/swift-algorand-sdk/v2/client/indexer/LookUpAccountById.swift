//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation


public struct LookUpAccountById: Request {
    public typealias ResponseType = AccountResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    init(client: IndexerClient, address: String) {
        self.client=client
        self.parameters = .init(path: "/v2/accounts/\(address)")
    }
}
