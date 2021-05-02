//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/4/21.
//
import MessagePacker
import Foundation
import CommonCrypto

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}
public class CustomEncoder{
    
    
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
    
    
    public static func decodeFrmMessagePack<T: Decodable>(obj:T.Type,data:Data)->T{
        let decoded = try! MessagePackDecoder().decode(obj, from: data)
        return decoded
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
    
    public static func convertToSha256(data:Data)->[Int8]{
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
       var resData =  Data(hash)
        var result=CustomEncoder.convertToInt8Array(input: Array(resData))
        
        return result
    }
    
    public static func decodeByteFromBase64(string:String)->[UInt8]{
        var stringEncoded = string.removingAllWhitespaces.padding(toLength: ((string.count+3)/4)*4,
                                           withPad: "=",
                                           startingAt: 0)
        var data:Data? = Data(base64Encoded: stringEncoded, options: .ignoreUnknownCharacters)
        let originalValues = Array(data!)
//        return convertToInt8Array(input: originalValues)
        return originalValues
    }
    
    public static func encodeToHexString(bytes:[Int8])->String{
        var uInt8Val = convertToUInt8Array(input: bytes)
        let data = Data(uInt8Val)
        return data.hexEncodedString()
    }
    
    public static func encodeToJson<T>(obj:T)->String where T : Encodable{
        
        let jsonData = try! JSONEncoder().encode(obj)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    public static func decodeFromJson<T>(json:String) throws ->T where T: Decodable{
        let decoded = try JSONDecoder().decode(T.self, from: (json.data(using: .utf8)!))
            return decoded
        
    }
}
