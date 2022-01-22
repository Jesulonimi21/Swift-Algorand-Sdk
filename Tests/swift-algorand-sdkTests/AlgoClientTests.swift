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
        
    func testAccountInformationRequests() {
        assertSuccessfulResponse(for: AccountInformation(client: client, address: "abc"), with: AccountData()) {
            XCTAssertEqual($0?.address, $1?.address)
        }
        assertErrorResponse(for: AccountInformation(client: client, address: "abc"))
    }
    
    func testHealthCheckRequests() {
        assertSuccessfulResponse(for: AlgodHealthCheck(client: client), with: "Check")
        assertSuccessfulResponse(for: AlgodHealthCheck(client: client), with: nil)
        assertErrorResponse(for: AlgodHealthCheck(client: client))
    }
    
    func testGenesisRequests() {
    
        assertSuccessfulResponse(for: GetGenesis(client: client), with: "{\"test\": \"TEST\"}") { response, _ in
            //TODO: Not quite sure about this internal conversion, need further investigation
            XCTAssertEqual(response, "\"{\\\"test\\\": \\\"TEST\\\"}\"")
        }
    }
    
}
