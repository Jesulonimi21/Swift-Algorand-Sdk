//
//  File.swift
//
//
//  Created by Jesulonimi on 3/4/21.
//

import Foundation
import XCTest
import swift_algorand_sdk
public class AccountTests : XCTestCase{
    func testSignatureVerification(){
        var bytes: [UInt8] = [1,2,3,4]
        var mnemonic="cactus check vocal shuffle remember regret vanish spice problem property diesel success easily napkin deposit gesture forum bag talent mechanic reunion enroll buddy about attract"
        var account = try! Account(mnemonic)
        var signedTx = account.keyPair.sign(bytes);
        var isVerified = try! account.keyPair.verify(signature: signedTx, message: bytes)
        XCTAssertEqual( isVerified, true)
    }
    
    
    func testTransactionSignatureVerification(){
        var mnemonic="cactus check vocal shuffle remember regret vanish spice problem property diesel success easily napkin deposit gesture forum bag talent mechanic reunion enroll buddy about attract"
                    var address = try! Address("VJQG6EJPZDAWFYLFF5XE3OMRQEK6RFFYSBVJOGXBH63ZQZ3QRRIUVIB7MY")
                   var tx = Transaction.paymentTransactionBuilder().setSender(address)
                    .amount(10)
                    .receiver(address)
                    .note("Swift Algo sdk is cool".bytes)
                   .build()
        var account = try! Account(mnemonic)
        var stxBytes:[UInt8] = account.keyPair.sign(CustomEncoder.encodeToMsgPack(tx))
        var isVerified = try! account.keyPair.verify(signature: stxBytes, message: CustomEncoder.encodeToMsgPack(tx))
        XCTAssertEqual( isVerified, true)
   
            
        
    }
    
    
    
    
    static var allTests = [
        ("testSignatureVerification", testSignatureVerification),
        ("testTransactionSignatureVerification",testTransactionSignatureVerification)
    ]
}
