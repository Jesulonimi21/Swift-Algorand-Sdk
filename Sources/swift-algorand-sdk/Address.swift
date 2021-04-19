//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/1/21.
//

import Foundation


enum AddressError:Error{
    case illegalArgumentException(String)
    case encodingError(String)
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
public class Address: Codable{
    
   
    public var bytes:[Int8]?=Array(repeating:0,count:32)
    enum CodingKeys:CodingKey{
        case bytes
    }
    
  public  var description:String{
        return try! self.encodeAsString()
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
    
    //TODO: Add method to verify bytes
    //TODO: Add Method to verify key
    //TODO: Add constructor to create bytes from string
    
    
    
   
    
}
