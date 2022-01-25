//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire

public struct LookUpApplicationsById: Request {
    public typealias ResponseType = ApplicationResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    init(client: IndexerClient, id: Int64) {
        self.client=client
        parameters = .init(path: "/v2/applications/\(id)")
    }
}
