//
//  File.swift
//
//
//  Created by Stefano Mondino on 20/01/22.
//

import Foundation
import Alamofire
import XCTest
@testable import swift_algorand_sdk

public class AlgodClientTests: XCTestCase {
    
    let client = AlgodClient (host: "https://somewhere.mocked", port: "8080", token: "t0k€n", session: .mocked)
        
    func testRequests() {
        assertSuccessfulResponse(for: AccountInformation(client: client, address: "abc"), with: AccountData())
    }
    
}
