//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/10/21.
//

import Foundation


public class RawTransaction: Request {
    public typealias ResponseType = PostTransactionsResponse
    public let client: HTTPClient
    private(set) public var parameters: RequestParameters
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, rawtxn: [Int8])` instead")
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "")
    }
    
    init(client: AlgodClient, rawtxn: [Int8]) {
        self.client = client
        parameters = .init(path: "/v2/transactions/",
                           headers: ["Content-type": "application/x-binary"],
                            method: .post,
                            encoding: ByteEncoding(data: Data(CustomEncoder.convertToUInt8Array(input: rawtxn))))
    }
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, rawtxn: [Int8])` instead")
    public func rawtxn(rawtaxn: [Int8]) -> RawTransaction {
        self.parameters = .init(path: "/v2/transactions/", headers: ["Content-type": "application/x-binary"],
                                method: .post,
                                encoding: ByteEncoding(data: Data(CustomEncoder.convertToUInt8Array(input: rawtaxn))))
        return self
    }
    
}
