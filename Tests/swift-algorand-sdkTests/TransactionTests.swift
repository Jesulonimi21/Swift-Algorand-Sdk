//
//  File.swift
//  
//
//  Created by Jesulonimi on 4/24/21.
//

import Foundation
import swift_algorand_sdk
import XCTest
import Ed25519

public class TransactionTests:XCTestCase{
    private static var DEFAULT_ACCOUNT = initializeDefaultAccount();
    public static func initializeDefaultAccount()->Account{
        var mnemonic =  "awful drop leaf tennis indoor begin mandate discover uncle seven only coil atom any hospital uncover make any climb actor armed measure need above hundred"
        return  try! Account(mnemonic)
    }
    
    private func assertEqual(actual:Transaction, expected:Transaction) {
        XCTAssertEqual(actual, expected)
        XCTAssertEqual(actual.sender, expected.sender)
        XCTAssertEqual(actual.receiver , expected.receiver)
        XCTAssertEqual(actual.amount, expected.amount)
        XCTAssertEqual(actual.lastValid, expected.lastValid)
        XCTAssertEqual(actual.genesisHash, expected.genesisHash)

       }


}
