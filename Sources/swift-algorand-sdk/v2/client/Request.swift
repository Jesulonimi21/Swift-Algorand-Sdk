//
//  File.swift
//  
//
//  Created by Stefano Mondino on 19/01/22.
//

import Foundation
import Alamofire

public protocol Request {
    associatedtype ResponseType: Codable
    var client: AlgodClient { get }
    var parameters: RequestParameters { get }
    func execute(callback: @escaping (_:Response<ResponseType>) -> Void)
}

public struct RequestParameters {
   
    let headers: [String: String]
    let path: String
    let method: HTTPMethod
    let queryParameters: [String: String]
    let bodyParameters: [String: Any]?
    let encoding: ParameterEncoding
    
    init(headers: [String : String] = [:],
         path: String,
         method: HTTPMethod = .get,
         queryParameters: [String : String] = [:],
         bodyParameters: [String : Any]? = nil,
         encoding: ParameterEncoding = URLEncoding.default) {
        self.headers = headers
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.encoding = encoding
    }
    
    func request(from client: AlgodClient) -> DataRequest {
        var components = client.connectString()
        components.path += self.path
        components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        let headers = self.headers.merging([client.apiKey: client.token]) { local, global in global  }
        return client.session.request(components.url?.absoluteString ?? "",
                          method: method,
                          parameters: bodyParameters,
                          headers: .init(headers),
                          requestModifier: { $0.timeoutInterval = 120.0 })
            .validate()
    }
}

struct ByteEncoding: ParameterEncoding {
  private let data: Data

  init(data: Data) {
    self.data = data
  }

  func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    var urlRequest = try urlRequest.asURLRequest()
    urlRequest.httpBody = data
    return urlRequest
  }
}

public extension Request {

    func execute( callback: @escaping (_:Response<ResponseType>) ->Void){
        let request = parameters.request(from: client)
        let customResponse: Response<ResponseType> = Response()
        request.responseDecodable(of: ResponseType.self){  (response) in
            if let error = response.error {
                customResponse.setIsSuccessful(value: false)
                let errorDescription = String(data: response.data ??
                                              error.errorDescription?.data(using: .utf8) ??
                                              Data(), encoding: .utf8)
                customResponse.setErrorDescription(errorDescription: errorDescription ?? "")
                callback(customResponse)
                if let data = response.data,
                   let message = String(data: data, encoding: .utf8),
                   let dictionary = try? JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any] {
                    customResponse.errorMessage = dictionary["message"] as? String
                }
                return
            }
            
            guard let data = response.value else {
                return
            }
            
            customResponse.setData(data: data)
            customResponse.setIsSuccessful(value:true)
            callback(customResponse)
            
        }
    }
}



