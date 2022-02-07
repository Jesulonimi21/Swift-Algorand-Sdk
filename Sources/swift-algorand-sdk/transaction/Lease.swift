//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/22/21.
//

import Foundation

public class Lease {
    public var LEASE_LENGTH:Int = 32;
    private var data:[Int8];

    public convenience init() throws {
        try  self.init(lease: Self.makeRandomLease());
    }

    public convenience init(lease:String) throws {
        var base64Array=CustomEncoder.convertBase64ToByteArray(data1: lease)
      try  self.init(lease:CustomEncoder.convertToInt8Array(input: base64Array));
    }


    public  init(lease:[Int8]) throws {
        if (!Lease.valid(value: lease)) {
            throw Errors.illegalArgumentError("Leases should be 0 or 32 bytes long, received: \(lease.count )  bytes");
        } else {
            self.data = lease;
        }
    }

  
    public func getBytes() ->[Int8]{
    return self.data
    }

    public func toString() ->String {
        return CustomEncoder.encodeToBase64(self.data);
    }

   
    private static func valid(value:[Int8]) ->Bool{
        return value.count == 32 || value.count == 0;
    }

    private static  func makeRandomLease() ->[Int8] {
     
        return CustomEncoder.convertToInt8Array(input:CustomEncoder.convertBase64ToByteArray(data1: Self.generateRandomBytes()!));
    }
    
  static  func generateRandomBytes() -> String? {
        var keyData = Data(count: 32)
        let result = keyData.withUnsafeMutableBytes {
            (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
            SecRandomCopyBytes(kSecRandomDefault, 32, mutableBytes)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
}
