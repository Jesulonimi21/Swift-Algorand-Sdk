//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/15/21.
//

import Foundation

public struct AccountInformation: Request {
    public typealias ResponseType = AccountData
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, address: String) {
        self.client = client
        self.parameters = .init(path: "/v2/accounts/\(address)")
    }
}
