//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation

public struct GetApplicationById: Request {
    public typealias ResponseType = Application
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, applicationId: Int64) {
        self.client=client
        self.parameters = .init(path: "/v2/applications/\(applicationId)")
    }
}
