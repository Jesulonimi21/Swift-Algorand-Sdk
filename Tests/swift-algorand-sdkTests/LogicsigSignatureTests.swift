//
//  File.swift
//  
//
//  Created by Jesulonimi on 4/21/21.
//

import Foundation
import XCTest
import swift_algorand_sdk

public class LogicsigSignatureTests:XCTestCase{
  
    
    public func testLogicsigCreation(){
        var program:[Int8] = [1,32,1,1,34]
        var args: [[Int8]] = Array()
        var programHash = "6Z3C3LDVWGMX23BMSYMANACQOSINPFIRF77H7N3AWJZYV6OH6GWTJKVMXY"
        var sender = try!  Address(programHash)
        var lsig = LogicsigSignature(logicsig: program)
        
        XCTAssertEqual(lsig.logic, program)
        XCTAssert(lsig.args==nil)
        XCTAssert(lsig.sig==nil)
        XCTAssert(lsig.msig==nil)
        try! XCTAssertEqual(lsig.toAddress().bytes, sender.bytes)
        var arg1:[Int8] = [1,2,3]
        var arg2:[Int8] = [4,5,6]
        args.append(arg1)
        args.append(arg2)
        
        lsig = LogicsigSignature(logicsig: program, args: args)
        XCTAssertEqual(lsig.logic, program)
        XCTAssertEqual(lsig.args, args)
        XCTAssert(lsig.sig==nil)
        XCTAssert(lsig.msig==nil)
        var outBytes:[UInt8] = CustomEncoder.encodeToMsgPack(lsig)
        var lsig1  = CustomEncoder.decodeFrmMessagePack(obj: LogicsigSignature.self, data: Data(outBytes))
        XCTAssertEqual(lsig, lsig1)

    }


}
