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
    func assertSuccessfulResponse<CustomRequest>(for request: CustomRequest,
                                                 with mock: CustomRequest.ResponseType,
                                                 file: StaticString = #filePath,
                                                 line: UInt = #line,
                                                 comparing compare: @escaping(CustomRequest.ResponseType?, CustomRequest.ResponseType?) -> Void)
    where CustomRequest: swift_algorand_sdk.Request {
        MockURLProtocol.response(for: request, with: mock)
        let expectation = XCTestExpectation(description: "Performing request for \(request.self)")
        request.execute { response in
            compare(response.data, mock)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    func assertSuccessfulResponse<CustomRequest>(for request: CustomRequest,
                                                 with mock: CustomRequest.ResponseType,
                                                 file: StaticString = #filePath,
                                                 line: UInt = #line)
    where CustomRequest: swift_algorand_sdk.Request, CustomRequest.ResponseType: Equatable {
        assertSuccessfulResponse(for: request,
                                    with: mock,
                                    file: file,
                                    line: line,
                                    comparing: { XCTAssertEqual($0, $1) })
    }
    
    func assertErrorResponse<CustomRequest: swift_algorand_sdk.Request>(for request: CustomRequest,
                                                                        code: Int = 400,
                                                                        message: String = "There was some error",
                                                                             file: StaticString = #filePath,
                                                                             line: UInt = #line) {
        MockURLProtocol.responseWithFailure(code: code, message: message)
        let expectation = XCTestExpectation(description: "Performing request for \(request.self)")
        request.execute { response in
            XCTAssertEqual(response.errorMessage, message)
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

    static func responseWithFailure(code: Int, message: String = "There was an error") {
        let encoder = JSONEncoder()
        let mock = ResponseError(message: message)
        MockURLProtocol.responseType = MockURLProtocol.ResponseType
            .success(HTTPURLResponse(url: URL(string: "https://something.useless")!,
                                     statusCode: code,
                                     httpVersion: nil, headerFields: nil)!,
                     try? encoder.encode(mock))
    }
    
    static func response<CustomRequest>(for request: CustomRequest,
                                        with mock: CustomRequest.ResponseType)
    where CustomRequest: swift_algorand_sdk.Request {
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
