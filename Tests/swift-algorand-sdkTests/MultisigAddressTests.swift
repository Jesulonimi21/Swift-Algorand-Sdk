//
//  File.swift
//  
//
//  Created by Jesulonimi on 4/20/21.
//

import Foundation
import swift_algorand_sdk
import XCTest

public class MultisigAddressTests:XCTestCase{
    func testToString(){
        var one = try! Address("XMHLMNAVJIMAW2RHJXLXKKK4G3J3U6VONNO3BTAQYVDC3MHTGDP3J5OCRU")
        var two = try! Address("HTNOX33OCQI2JCOLZ2IRM3BC2WZ6JUILSLEORBPFI6W7GU5Q4ZW6LINHLA")
        var three = try! Address("E6JSNTY4PVCY3IRZ6XEDHEO6VIHCQ5KGXCIQKFQCMB2N6HXRY4IB43VSHI")
        
        var addr = try! MultisigAddress(version: 1, threshold: 2, publicKeys: [
            Ed25519PublicKey(bytes: one.getBytes()),
            Ed25519PublicKey(bytes: two.getBytes()),
            Ed25519PublicKey(bytes: three.getBytes())
        ])
       try! XCTAssertEqual(addr.toAddress().description, "UCE2U2JC4O4ZR6W763GUQCG57HQCDZEUJY4J5I6VYY4HQZUJDF7AKZO5GM")
        TestUtil.serializeDeserializeCheck(object: addr)
    }
    

}
