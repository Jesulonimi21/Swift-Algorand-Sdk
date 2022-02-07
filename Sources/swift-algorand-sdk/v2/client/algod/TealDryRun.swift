//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/2/21.
//

import Foundation


public class TealDryRun: Request {
    public typealias ResponseType = DryrunResponse
    public let client: HTTPClient
    private(set) public var parameters: RequestParameters

    init(client: AlgodClient, request: DryrunRequest) throws {
        self.client = client
        parameters = .init(path: "/v2/teal/dryrun",
                           headers: ["Content-type": "application/x-binary"],
                           method: .post,
                           encoding: ByteEncoding(data: Data( try CustomEncoder.encodeToMsgPack(request))))
    }
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, request: DryrunRequest)` instead")
    public init(client: AlgodClient) {
        self.client = client
        self.parameters = .init(path: "")
    }
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, request: DryrunRequest)` instead")
    public func request(request: DryrunRequest) throws -> TealDryRun {
        parameters = .init(path: "/v2/teal/dryrun", headers: ["Content-type": "application/x-binary"],
                           method: .post,
                           encoding: ByteEncoding(data: Data(try CustomEncoder.encodeToMsgPack(request))))
        return self
    }
}
