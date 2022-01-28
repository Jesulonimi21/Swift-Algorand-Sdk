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

public class IndexerClientTests: XCTestCase {
    
    let client = IndexerClient(host: "https://somewhere.mocked",
                                port: "8081",
                                token: "t0k€n",
                                session: .mocked)
    
    func testLookUpAccountById() {
        let object = AccountResponse(account: AccountData(address: "abc"),
                                     currentRound: 123)
        let request = LookUpAccountById(client: client, address: "abc")
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testLookUpAccountTransactions() {
        let object = TransactionsResponse()
        let request = LookUpAccountTransactions(client: client, address: "abc")
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testLookUpApplicationsById() {
        let object = ApplicationResponse()
        let request = LookUpApplicationsById(client: client, id: 1234)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testLookUpApplicationLogsById() {
        let object = ApplicationLogResponse()
        let request = LookUpApplicationLogsById(client: client,
                                                 applicationId: 1234,
                                                next: "test")
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testLookUpAssetBalances() {
        let object = AssetBalancesResponse(balances: [], currentRound: 123, nextToken: "nextToken")
        let request = LookUpAssetBalances(client: client, assetId: 1234)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testLookUpAssetById() {
        let object = AssetResponse(currentRound: 1)
        let request = LookUpAssetById(client: client, id: 1234)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testLookUpAssetTransactions() {
        let object = TransactionsResponse(currentRound: 12345, nextToken: "next", transactions: [])
        let request = LookUpAssetTransactions(client: client, assetId: 1234)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testLookUpBlock() {
        let object = Block(
            genesisId: "testId",
            round: 1234
        )
        let request = LookupBlock(client: client, roundNumber: 1234)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testMakeHealthCheck() {
        let object = HealthCheck()
        let request = MakeHealthCheck(client: client)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testSearchForAccount() {
        let object = AccountsResponse()
        let request = SearchForAccounts(client: client)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testSearchForApplications() {
        let object = ApplicationsResponse()
        let request = SearchForApplications(client: client)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testSearchForAssets() {
        let object = AssetsResponse(currentRound: 12354)
        let request = SearchForAssets(client: client)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
    
    func testSearchForTransactions() {
        let object = TransactionsResponse(currentRound: 12354)
        let request = SearchForTransactions(client: client)
        assertSuccessfulResponse(for: request, with: object)
        assertErrorResponse(for: request)
    }
}
