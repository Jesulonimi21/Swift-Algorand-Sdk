//
//  File.swift
//  
//
//  Created by Stefano Mondino on 08/05/22.
//

import Foundation
import XCTest
@testable import swift_algorand_sdk

public class BinaryDataConversionTests: XCTestCase {
    
    struct TestValue: Codable, Equatable {
        var data: [Int8]? {
            get { dataString?.value }
            set { dataString = .init(newValue) }
        }
        var dataString: BinaryData?
    }
    
    func testBinaryConvertionWorksProperly() throws {
        
        let string = "dGVzdA==" // "test" in base64
        let json = """
        { "dataString": "\(string)"}
        """
        let bytes: [Int8] = [116, 101, 115, 116] // "test" in bytes
        let testValue = try JSONDecoder().decode(TestValue.self, from: json.data(using: .utf8) ?? Data())
        
        XCTAssertEqual(testValue.data, bytes)
        var test = TestValue()
        test.data = bytes
        let encoded = try JSONEncoder().encode(test)
        let dictionary = try JSONSerialization.jsonObject(with: encoded) as? [String: String]
        XCTAssertEqual(dictionary?["dataString"], string)
        
    }
}
