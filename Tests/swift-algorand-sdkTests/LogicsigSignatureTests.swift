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
        var lsig = try! LogicsigSignature(logicsig: program)
        
        XCTAssertEqual(lsig.logic, program)
        XCTAssert(lsig.args==nil)
        XCTAssert(lsig.sig==nil)
        XCTAssert(lsig.msig==nil)
        try! XCTAssertEqual(lsig.toAddress().bytes, sender.bytes)
        var arg1:[Int8] = [1,2,3]
        var arg2:[Int8] = [4,5,6]
        args.append(arg1)
        args.append(arg2)
        
        lsig = try! LogicsigSignature(logicsig: program, args: args)
        XCTAssertEqual(lsig.logic, program)
        XCTAssertEqual(lsig.args, args)
        XCTAssert(lsig.sig==nil)
        XCTAssert(lsig.msig==nil)
        var outBytes:[UInt8] = CustomEncoder.encodeToMsgPack(lsig)
        var lsig1  = CustomEncoder.decodeFrmMessagePack(obj: LogicsigSignature.self, data: Data(outBytes))
        XCTAssertEqual(lsig, lsig1)

    }
    
    public func testLogicsigInvalidProgramCreation(){
        var program:[Int8] = [127,32,1,1,34,]
        var thrownError: Error?
        XCTAssertThrowsError(try LogicsigSignature(logicsig: program)){
            thrownError = $0
        }
        XCTAssertTrue(thrownError is Errors, "Unexpected error type: \(type(of: thrownError))")
        
        XCTAssertEqual(thrownError as? Errors, .illegalArgumentError("unsupported version"))
        
    }
    
    public func testLogicsigSignature(){
        var program:[Int8] = [1,32,1,1,34,]
        var lsig = try! LogicsigSignature(logicsig: program)
        var account = try! Account()
        lsig = try! account.signLogicsig(lsig: lsig)
        XCTAssertEqual(lsig.logic, program)
        XCTAssertEqual(lsig.args, nil)
        XCTAssertEqual(lsig.msig, nil)
        
        var outBytes:[UInt8] = CustomEncoder.encodeToMsgPack(lsig)
        var lsig1 = CustomEncoder.decodeFrmMessagePack(obj: LogicsigSignature.self, data: Data(outBytes))
      
        let jsonData = try! JSONEncoder().encode(lsig1)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
        print( String(data: try! JSONEncoder().encode(lsig), encoding: .utf8)!)
        XCTAssertEqual(lsig1, lsig)
    }
    
    public func testLogicsigMultisigSignature(){
        var verified = false
        var program:[Int8] = [1,32,1,1,34,]
        
        var one = try! Address("DN7MBMCL5JQ3PFUQS7TMX5AH4EEKOBJVDUF4TCV6WERATKFLQF4MQUPZTA")
        var two = try! Address("BFRTECKTOOE7A5LHCF3TTEOH2A7BW46IYT2SX5VP6ANKEXHZYJY77SJTVM")
        var three = try! Address("47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU")
        
        var ma = try! MultisigAddress(version: 1, threshold: 2, publicKeys: [
            Ed25519PublicKey(bytes: one.getBytes()),
            Ed25519PublicKey(bytes: two.getBytes()),
            Ed25519PublicKey(bytes: three.getBytes()),
        ])
        var mn1 = "auction inquiry lava second expand liberty glass involve ginger illness length room item discover ahead table doctor term tackle cement bonus profit right above catch"
        var mn2 = "since during average anxiety protect cherry club long lawsuit loan expand embark forum theory winter park twenty ball kangaroo cram burst board host ability left"
        var acc1 = try! Account(mn1)
        var acc2 = try! Account(mn2)
        var account = try! Account()
        
        var lsig =  try! LogicsigSignature(logicsig: program)
        lsig = try! acc1.signLogicsig(lsig: lsig,ma: ma)
        
        XCTAssertEqual(lsig.logic, program)
        XCTAssertEqual(lsig.args, nil)
        XCTAssertEqual(lsig.sig, nil)
        XCTAssertNotEqual(lsig.msig, MultisigSignature())
        
        var lsigLambda = lsig
        var thrownError: Error?
        XCTAssertThrowsError(try account.appendToLogicsig(lsig: lsigLambda)){
            thrownError = $0
        }
        XCTAssertTrue(thrownError is Errors, "Unexpected error type: \(type(of: thrownError))")
        
        XCTAssertEqual(thrownError as? Errors, .illegalArgumentError("Multisig account does not contain this secret key"))
        
        verified = lsig.verify(address: try!ma.toAddress());
        XCTAssertFalse(verified)
        
        lsig = try! acc2.appendToLogicsig(lsig: lsig)
        verified = lsig.verify(address: try! ma.toAddress());
        XCTAssertTrue(verified)
        var lsig1 = try! LogicsigSignature(logicsig: program)
         lsig1 = try! account.signLogicsig(lsig: lsig1)
        lsig.sig = lsig1.sig
        verified = lsig.verify(address: try! ma.toAddress())
        XCTAssert(verified==false)
        verified = lsig.verify(address: account.getAddress())
        XCTAssertFalse(verified)
        
        lsig.sig=nil
        
        verified =  lsig.verify(address:try! ma.toAddress())
        XCTAssertTrue(verified)
        
        
        var outBytes:[UInt8] = CustomEncoder.encodeToMsgPack(lsig)
        var lsig2 = CustomEncoder.decodeFrmMessagePack(obj: LogicsigSignature.self, data: Data(outBytes))
        XCTAssertEqual(lsig2, lsig)
        verified = lsig2.verify(address: try! ma.toAddress())
        XCTAssertTrue(verified)
        
    }


}
