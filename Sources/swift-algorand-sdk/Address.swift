//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/1/21.
//

import Foundation
import Ed25519

enum AddressError:Error{
    case illegalArgumentException(String)
    case encodingError(String)
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
public class Address: Codable,Equatable{
    
    static var APP_ID_PREFIX: [Int8] = [97, 112, 112, 73, 68]
    public var bytes:[Int8]?=Array(repeating:0,count:32)
//    enum CodingKeys:CodingKey{
//        case bytes
//    }
    public var BYTES_SIGN_PREFIX: [Int8] = [77,88];
  public  var description:String{
        return (try? self.encodeAsString()) ?? ""
    }
    public init(_ bytes:[Int8]) throws{
        if(bytes.count != 32){
            throw AddressError.illegalArgumentException("Given address length is not 32")
        }
        self.bytes=bytes
        
    }
    
    public init(){
        
    }
    
    public init(_ encodedAddress:String) throws {
        var checksumAddr=CustomEncoder.convertToInt8Array(input: Array(Base32Decode(data:encodedAddress)!))
       if (checksumAddr.count != 36) {
        throw AddressError.illegalArgumentException("Input string is an invalid address. Wrong length")
       } else {
            var checksum:[Int8] = Array(repeating: 0, count: 4)
        for i in 0..<4{
            checksum[i]=checksumAddr[32+i]
        }

        var addr:[Int8]=Array(repeating: 0, count: 32)
        for i in 0..<32{
            addr[i]=checksumAddr[i]
        }
        var hashedAddr=SHA512_256().hash(addr)
        
        var expectedChecksum:[Int8]=Array(repeating: 0, count: 4)
        for i in 0..<4{
            expectedChecksum[i]=hashedAddr[28+i]
        }
        if(checksum.containsSameElements(as: expectedChecksum)){
            self.bytes=addr
        }else{
            throw AddressError.illegalArgumentException("Input checksum did not validate");
        }
        
       }
    }
    
    func encodeAsString()throws->String {
        if let ed25519PubKey=bytes{
            var sha512hash=SHA512_256().hash(ed25519PubKey)
            var checkSumAddress:[Int8] = Array(repeating: 0, count: 36)
            for i in 0..<32{
                checkSumAddress[i]=ed25519PubKey[i]
            }
            var rowCounter=28
            for i in 32..<36{
             checkSumAddress[i]=sha512hash[rowCounter]
                rowCounter=rowCounter+1
            }
            let uint8ChecksumAddr=checkSumAddress.map{(int8Byte) -> UInt8 in
                return unsafeBitCast(int8Byte, to: UInt8.self)
            }
            let dat = Data(uint8ChecksumAddr)
            let Uint8Base32Address = Base32Encode(data: dat)
            let base32Address=Uint8Base32Address.replacingOccurrences(of: "=", with: "")
            return base32Address
        }else{
            throw AddressError.encodingError("unexpected address length")
        }
        return "";
    }
    
   public func getBytes()->[Int8]{
        return self.bytes!
    }
    

    public func verifyBytes(byte: [Int8], signature: Signature)throws -> Bool{
        var publicKey = try self.toVerifyKey();
        var prefixBytes: [Int8] = Array(repeating: 0, count: byte.count + BYTES_SIGN_PREFIX.count);
        var isVerified = try publicKey.verify(signature: CustomEncoder.convertToUInt8Array(input: signature.bytes!), message: CustomEncoder.convertToUInt8Array(input: byte))
        return isVerified
    }
    
    
    
    public func toVerifyKey() throws -> PublicKey{
        if let bytes = self.bytes{
            let publicKey = try PublicKey(CustomEncoder.convertToUInt8Array(input: (bytes)))
            return publicKey
        }else{
            throw Errors.runtimeError("Address bytes was null")
        }
       
    }
    
    
    public static func == (lhs:Address,rhs:Address)->Bool{
        return lhs.bytes==rhs.bytes
    }
    
    public required init(from decoder: Decoder) throws {
        var container = try? decoder.singleValueContainer()
        var bytesData = try? container?.decode(Data.self)
        if let bytes =  bytesData{
            self.bytes = CustomEncoder.convertToInt8Array(input: Array(bytes))
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = try? encoder.singleValueContainer()
        if let b = self.bytes{
          try  container?.encode(Data(CustomEncoder.convertToUInt8Array(input: b)))
        }
    }
    
    public static func forApplication(appId: UInt64) throws -> Address{
        let digest = try SHA512_256().hash( APP_ID_PREFIX + CustomEncoder.encodeUInt64(appId))
        return try Address(digest)
    }
    
}
