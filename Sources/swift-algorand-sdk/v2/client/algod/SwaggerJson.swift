//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation

public struct SwaggerJson: Request {
    public typealias ResponseType = String
    public let client: HTTPClient
    public let parameters: RequestParameters
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "/swagger.json")
    }
//
    public func execute( callback: @escaping (_:Response<String>) -> Void) {
        let request = parameters.request(from: client)
        let customResponse: Response<String> = Response()
        request.responseData { response in
            switch response.result {
            case .success:
                customResponse.setData(data: String(data: response.data ?? Data(), encoding: .utf8) ?? "nil")
                customResponse.setIsSuccessful(value: true)
                callback(customResponse)
            case .failure(let error):
                customResponse.setErrorDescription(errorDescription: error.localizedDescription)
                customResponse.setIsSuccessful(value: false)
                callback(customResponse)
            }
        }
        
    }
}
