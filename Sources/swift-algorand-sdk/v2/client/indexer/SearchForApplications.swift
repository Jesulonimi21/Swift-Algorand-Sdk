//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire

public struct SearchForApplications: Request {
    public typealias ResponseType = ApplicationsResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    init(client: IndexerClient) {
        self.client = client
        parameters = .init(path: "/v2/applications")
    }
}
