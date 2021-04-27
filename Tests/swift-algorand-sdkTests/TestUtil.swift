//
//  File.swift
//  
//
//  Created by Jesulonimi on 4/26/21.
//

import Foundation
import swift_algorand_sdk
import XCTest
public class TestUtil{
//    <T>(obj:T)->String where T : Encodable
    public static func serializeDeserializeCheck<T:Codable>(object:T) where T:Equatable{
        TestUtil.jsonSerializeTests(object: object)
        TestUtil.messagePackSerializeTests(object: object)
    }
    
    public static func jsonSerializeTests<T:Codable>(object:T) where T:Equatable{
        var encoded:String?
        var encoded2:String?
        
        var decoded : T?
        var decoded2:T?
    
        encoded = CustomEncoder.encodeToJson(obj: object)
        decoded = try! CustomEncoder.decodeFromJson(json: encoded!) as T

        
        XCTAssertEqual(decoded, object)
        
        encoded2 = CustomEncoder.encodeToJson(obj: decoded)
        XCTAssertEqual(encoded2, encoded)
        
        decoded2 = try! CustomEncoder.decodeFromJson(json: encoded2!)
        XCTAssertEqual(decoded2, decoded)
    }
        
    
   public static func messagePackSerializeTests<T:Codable>(object:T) where T:Equatable{
        var encoded:[UInt8]?
        var encoded2:[UInt8]?
        
        var decoded : T?
        var decoded2:T?
        
        encoded = CustomEncoder.encodeToMsgPack(object)
        decoded = try! CustomEncoder.decodeFrmMessagePack(obj: T.self, data: Data(encoded!))
        
        XCTAssertEqual(decoded, object)
        
        
        encoded2 = CustomEncoder.encodeToMsgPack(decoded)
        XCTAssertEqual(encoded2, encoded)
        
        
        decoded2 = try! CustomEncoder.decodeFrmMessagePack(obj: T.self, data: Data(encoded2!))
        XCTAssertEqual(decoded2, decoded)
    }
    
    
    
}


