//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/4/21.
//
import MessagePacker
import Foundation
class CustomEncoder{
    
    public static func encodeToMsgPack <T: Encodable>(_ obj:T)-> [Int8]{
        let encoder =  MessagePackEncoder()
        let value = try! encoder.encode(obj)
        let int8Val=value.map{
            uint8Val -> Int8 in
            return unsafeBitCast(uint8Val, to: Int8.self)
        }
        return int8Val
    }
    public static func encodeToMsgPack <T: Encodable>(_ obj:T)-> [UInt8]{
        let encoder =  MessagePackEncoder()
        let value = try! encoder.encode(obj)
        return Array(value)
    }
    
    public static func encodeToBase32StripPad(_ uBytes :[Int8])-> String{
        let bytes=uBytes.map{uint8Val -> UInt8 in return unsafeBitCast(uint8Val, to: UInt8.self)}
        let dat = Data(bytes)
        let Uint8Base32String = Base32Encode(data: dat)
        let base32String=Uint8Base32String.replacingOccurrences(of: "=", with: "");
        return base32String;
    }
    
    public static func decodeFromBase32StripPad(_ input:String)->[Int8]{
        let data=Base32Decode(data: input)
        
        let originalValue = Array(data!)
        let result = originalValue.map{int8Val -> Int8 in return unsafeBitCast(int8Val, to: Int8.self)}
        return result
    }
    
    public static func convertToInt8Array(input:[UInt8]) -> [Int8]{
        return input.map{uint8Val -> Int8 in return unsafeBitCast(uint8Val, to: Int8.self)}
    }
    public static func convertToUInt8Array(input:[Int8]) -> [UInt8]{
        return input.map{int8Val -> UInt8 in return unsafeBitCast(int8Val, to: UInt8.self)}
    }
    
    
    public static func encodeToBase64(_ data:Data) -> String{
        return data.base64EncodedString()
    }
    
    public static func encodeToBase64(_ data:[Int8]) -> String{
        return  encodeToBase64(Data(convertToUInt8Array(input: data) ))
    }
    
    public static func encodeToBase64(_ data:[UInt8]) -> String{
        return  encodeToBase64(Data(data))
    }
    
    public static func  decodeFromBase64(_ input:[UInt8])->Data{
            return Data(input)
    }
    public static func convertBase64ToByteArray(data1:String)->[UInt8]{
         let nsdata1 = Data(base64Encoded: data1, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!

            let arr2 = nsdata1.withUnsafeBytes {
               Array(UnsafeBufferPointer<UInt8>(start: $0, count: nsdata1.count/MemoryLayout<UInt8>.size))
            }

            return arr2
        
    }
    
}
