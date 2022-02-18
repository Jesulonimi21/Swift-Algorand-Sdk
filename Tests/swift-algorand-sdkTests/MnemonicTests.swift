//
//  File.swift
//  
//
//  Created by Jesulonimi on 4/24/21.
//

import Foundation
import swift_algorand_sdk
import XCTest
public class MnemonicTests:XCTestCase{
    func testZeroVector() throws {
        var zeroKeys:[Int8] = Array(repeating: 0, count: 32)
        var expectedMn = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon invest"
        var mn = try Mnemonic.fromKey(zeroKeys)
        XCTAssertEqual(mn, expectedMn)
        var goBack = try Mnemonic.toKey(mn)
        XCTAssertEqual(goBack, zeroKeys)
    }
    
    func testWordNotInList(){
        var mn =  "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon zzz invest"
        var thrownError:Error?
        XCTAssertThrowsError(try Mnemonic.toKey(mn)){
            thrownError = $0
        }
        XCTAssertTrue(thrownError is Errors, "Unexpected error type: \(type(of: thrownError))")
        
        XCTAssertEqual(thrownError as? Errors, .illegalArgumentError("mnemonic contains word that is not in word list"))
    }
    func generateRandomBytes(_ length:Int=32) -> [Int8]? {
        var keyData = Data(count: length)
        let result = keyData.withUnsafeMutableBytes {
            (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
            SecRandomCopyBytes(kSecRandomDefault, length, mutableBytes)
        }
        if result == errSecSuccess {
          return CustomEncoder.convertToInt8Array(input: Array(keyData))
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
   

    func testGenerateAndRecovery() throws {
        for i in 0...1000{
            var randKey =  generateRandomBytes()
            var mn = try Mnemonic.fromKey(randKey!)
            var regenKey = try Mnemonic.toKey(mn)
            XCTAssertEqual(regenKey, randKey)
        }
    }
    
    func testCorruptedChecksum() throws {
        for i in 0...1000{
            var randKey = generateRandomBytes()!
            var mn = try Mnemonic.fromKey(randKey)
            var words = mn.components(separatedBy: " ")
            var oldWord:String = words[words.count-1]
            var newWord:String = oldWord
            while oldWord == newWord{
                newWord = Constants.RAW[Int.random(in: 0..<2^11)]
            }
            words[words.count-1] = newWord
            var s = ""
            for i in 0..<words.count{
                if i > 0{
                    s+=" "
                }
                s+=words[i]
            }
            var corruptedMn = s
            var thrownError:Error?
         
       
            XCTAssertThrowsError(try Mnemonic.toKey(corruptedMn)){
                thrownError = $0
            }
            XCTAssertTrue(thrownError is Errors, "Unexpected error type: \(type(of: thrownError))")

            XCTAssertEqual(thrownError as? Errors, .generalSecurityError("checksum failed to validate"))
        }
    }

    
    func testInvalidKeylen(){
        var badLength = [ 0, 31, 33, 100, 35, 2, 30]
        
        for i in 0..<badLength.count{
            var randKey = generateRandomBytes(badLength.count)
            var thrownError:Error?
         
       
            XCTAssertThrowsError(try Mnemonic.fromKey(randKey!)){
                thrownError = $0
            }
            XCTAssertTrue(thrownError is Errors, "Unexpected error type: \(type(of: thrownError))")

            XCTAssertEqual(thrownError as? Errors, .illegalArgumentError("key length must be 32 bytes"))
        }
    }

}
