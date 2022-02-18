//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/1/21.
//

import Foundation


public class TealCompile: Request {
    public typealias ResponseType = CompileResponse
    
    public let client: HTTPClient
    public private(set) var parameters: RequestParameters
    
    init(client: AlgodClient, source: [Int8]) {
        self.client = client
        parameters = .init(path: "/v2/teal/compile",
                           headers: ["Content-type": "application/x-binary"],
                           method: .post,
                           encoding: ByteEncoding(data: Data(CustomEncoder.convertToUInt8Array(input: source))))
    }
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, source: [Int8])` instead")
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "")
    }
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, source: [Int8])` instead")
    public func source(source: [Int8]) -> TealCompile {
        self.parameters = .init(path: "/v2/teal/compile", headers: ["Content-type": "application/x-binary"],
                                method: .post,
                                encoding: ByteEncoding(data: Data(CustomEncoder.convertToUInt8Array(input: source))))
        return self
    }
}
