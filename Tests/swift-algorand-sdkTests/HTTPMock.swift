//
//  File.swift
//  
//
//  Created by Stefano Mondino on 21/01/22.
//

import Foundation
import Alamofire
import XCTest
@testable import swift_algorand_sdk

extension XCTestCase {
    func assertSuccessfulResponse<CustomRequest: swift_algorand_sdk.Request>(for request: CustomRequest,
                                                                             with mock: CustomRequest.ResponseType,
                                                                             file: StaticString = #filePath,
                                                                             line: UInt = #line) {
        MockURLProtocol.response(for: request, with: mock)
        let expectation = XCTestExpectation(description: "Performing request for \(request.self)")
        request.execute { response in
            XCTAssertNotNil(response.data)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

extension Alamofire.Session {
    static var mocked: Session = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            return configuration
        }()
        
        return Session(configuration: configuration)
    }()
}

final class MockURLProtocol: URLProtocol {
    
    private(set) var activeTask: URLSessionTask?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    override func startLoading() {
        if let urlRequest = request.urlRequest {
            activeTask = session.dataTask(with: urlRequest)
        }
        activeTask?.cancel()
    }

    override func stopLoading() {
        activeTask?.cancel()
    }
    
    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse, Data?)
    }
    static var responseType: ResponseType!
    
    enum MockError: Error {
        case none
    }
    
    static func responseWithFailure() {
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.error(MockError.none)
    }
    
    static func response<CustomRequest: swift_algorand_sdk.Request>(for request: CustomRequest,
    with mock: CustomRequest.ResponseType) {
        let encoder = JSONEncoder()
        MockURLProtocol.responseType = MockURLProtocol.ResponseType
            .success(HTTPURLResponse(url: URL(string: "https://something.useless")!,
                                     statusCode: 200,
                                     httpVersion: nil, headerFields: nil)!,
                     try? encoder.encode(mock))
    }
}

extension MockURLProtocol: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let response, let data):
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
        default:
            break
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}
