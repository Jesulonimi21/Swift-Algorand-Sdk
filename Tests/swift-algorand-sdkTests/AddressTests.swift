//
//  File.swift
//  
//
//  Created by Jesulonimi on 4/20/21.
//

import Foundation
import XCTest
import swift_algorand_sdk
public class AddressTests: XCTestCase{
    
    
      func generateRandomBytes() -> [Int8]? {
          var keyData = Data(count: 32)
          let result = keyData.withUnsafeMutableBytes {
              (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
              SecRandomCopyBytes(kSecRandomDefault, 32, mutableBytes)
          }
          if result == errSecSuccess {
            return CustomEncoder.convertToInt8Array(input: Array(keyData))
          } else {
              print("Problem generating random bytes")
              return nil
          }
      }
    
    
    func testEncodeDecodeStr(){
        for i in 0..<1000{
            var bytes = generateRandomBytes()
            var addr = try! Address(bytes!)
            var addrStr = addr.description
            var rencAddr = try! Address(addrStr)
            XCTAssertEqual(addr.bytes, rencAddr.bytes)
        }
    }

    func testGoldenValues(){
        var golden = "7777777777777777777777777777777777777777777777777774MSJUVU"
        var bytes:[Int8] = Array(repeating: 0, count: 32)
        for i in 0..<bytes.count{
            bytes[i] = -1
        }
       try! XCTAssertEqual(Address(bytes).description, golden)
        
    }
    
    
    func testEncodable(){
        var a = try! Address("VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ");
        var aBytes:[UInt8] = CustomEncoder.encodeToMsgPack(a)
        
        var o = CustomEncoder.decodeFrmMessagePack(obj: Address.self, data: Data(aBytes))
        
        XCTAssertEqual("VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ", o.description)
    }
}
