//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/6/21.
//

import Foundation
public class AssetParams: Codable,Equatable {
    public init(assetTotal: Int64?, assetDecimals: Int64?, assetDefaultFrozen: Bool?, assetUnitName: String?, assetName: String?, url: String? , metadataHash: [Int8]?, assetManager: Address? , assetReserve: Address?, assetFreeze: Address?, assetClawback: Address? ) throws {
        
        
        if let aDecimals = assetDecimals {
            if (aDecimals < 0 || aDecimals > 19) {
                throw Errors.runtimeError("assetDecimals cannot be less than 0 or greater than 19")
            }
               }

               if let aUnitName = assetUnitName {
                   if (aUnitName.count > 8) {
                    throw  Errors.runtimeError("assetUnitName cannot be greater than 8 characters")
                    
                   }
                
               }

               if let aName = assetName {
                   if (aName.count > 32){
                    throw Errors.runtimeError("assetName cannot be greater than 32 characters");
                   }
               }

               if let ul = url {
                   if (ul.count > 96) {
                    throw Errors.runtimeError("asset url cannot be greater than 32 characters")
                   }
               }

       
               if let mDataHash = metadataHash {
                   if (mDataHash.count > 32) {
                    throw Errors.runtimeError("asset metadataHash cannot be greater than 32 bytes")
                 
                   }
                let base64Regex = "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$"
                let predicate = NSPredicate(format: "SELF MATCHES %@", base64Regex)
                var string = String(bytes: CustomEncoder.convertToUInt8Array(input: mDataHash), encoding: .utf8)!
                var stringEncoded = string.removingAllWhitespaces.padding(toLength: ((string.count+3)/4)*4,
                                                   withPad: "=",
                                                   startingAt: 0)
                var data:Data? = Data(base64Encoded: stringEncoded, options: .ignoreUnknownCharacters)
               
                if (data==nil){
                    throw Errors.runtimeError("asset metadataHash \(String(bytes: CustomEncoder.convertToUInt8Array(input: mDataHash), encoding: .utf8)!) is not base64 encoded");
                }
               }
        
        
        self.assetTotal = assetTotal
        self.assetDecimals = assetDecimals
        self.assetDefaultFrozen = assetDefaultFrozen
        self.assetUnitName = assetUnitName
        self.assetName = assetName
        self.url = url
        self.metadataHash = metadataHash
        self.assetManager = assetManager
        self.assetReserve = assetReserve
        self.assetFreeze = assetFreeze
        self.assetClawback = assetClawback
    }
    
   public var assetTotal:Int64?
    public var assetDecimals:Int64? = 0
    public var assetDefaultFrozen:Bool? = false
    public var assetUnitName:String?
    public  var assetName:String?;
    public  var url:String?;
    public   var metadataHash:[Int8]?;
    public   var assetManager:Address?
    public   var  assetReserve:Address?;
    public  var assetFreeze:Address?;
    public  var assetClawback:Address?;

    
 
    
    enum CodingKeys:String,CodingKey{
        case assetTotal="t"
        case assetDecimals="dc"
        case assetDefaultFrozen="df"
        case assetUnitName="un"
        case assetName="an"
        case url="au"
        case metadataHash="am"
        case assetManager="m"
        case  assetReserve="r"
        case assetFreeze="f"
        case assetClawback="c"
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container=encoder.container(keyedBy: CodingKeys.self)
        if let metadatahash=self.metadataHash{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: metadatahash))  , forKey: .metadataHash)
        }
        if let assetName=self.assetName{
            try!container.encode(assetName, forKey: .assetName)
        }
    
        if let url=self.url{
            try!container.encode(url, forKey: .url)
        }
      
        if let assetClawBack=self.assetClawback{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetClawBack.getBytes())), forKey: .assetClawback)
          
        }
       
        if let assetDecimals=self.assetDecimals{
            if self.assetDecimals != 0{
                    try!container.encode(assetDecimals , forKey: .assetDecimals)
                }
        }
        
        
        if let assetDefaultFrozen=self.assetDefaultFrozen{
            if assetDefaultFrozen != false{
                    try!container.encode(assetDefaultFrozen, forKey: .assetDefaultFrozen)
                }
        }
   
        if let assetFreeze=self.assetFreeze{
             try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetFreeze.getBytes())), forKey: .assetFreeze)
        }
       
        if let assetManager=self.assetManager{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetManager.getBytes())), forKey: .assetManager)
        }
       
        if let assetReserve=self.assetReserve{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetReserve.getBytes())), forKey: .assetReserve)
        }
        if let assetTotal=self.assetTotal{
            try!container.encode(assetTotal, forKey: .assetTotal)
        }
        if let assetUnitName=self.assetUnitName{
            try!container.encode(assetUnitName , forKey: .assetUnitName)
          
          
        }
     
        
    }
    public required init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
//        var assetTotal:Int64?
//        var assetDecimals:Int64?
//        var assetDefaultFrozen:Bool?
//        var assetUnitName:String?
//        var assetName:String?;
//        var url:String?;
//        var metadataHash:[Int8]?;
//        var assetManager:Address?
//        var  assetReserve:Address?;
//        var assetFreeze:Address?;
//        var assetClawback:Address?;
        self.assetTotal = try? container.decode(Int64.self, forKey: .assetTotal)
        self.assetDecimals = try? container.decode(Int64.self,forKey: .assetDecimals)
        if let asD = self.assetDecimals{
            
        }else{
            self.assetDecimals  = 0
        }
        self.assetDefaultFrozen = try? container.decode(Bool.self,forKey: .assetDefaultFrozen)
        if let aDf =  self.assetDefaultFrozen{
        
        }else{
            self.assetDefaultFrozen=false
        }
        self.assetUnitName = try? container.decode(String.self,forKey: .assetUnitName)
        self.assetName = try? container.decode(String.self,forKey: .assetName)
        self.url = try? container.decode(String.self,forKey: .url)
        
        var metaDataHashData = try? container.decode(Data.self,forKey: .metadataHash)
        if let metadataHash = metaDataHashData{
            self.metadataHash = CustomEncoder.convertToInt8Array(input: Array(metadataHash))
        }
        self.assetManager = try? container.decode(Address.self,forKey: .assetManager)
        self.assetReserve = try? container.decode(Address.self,forKey: .assetReserve)
        self.assetFreeze     = try? container.decode(Address.self,forKey: .assetFreeze)
        self.assetClawback = try? container.decode(Address.self,forKey: .assetClawback)
        
        
    }
    
    public static func == (lhs:AssetParams,rhs:AssetParams)->Bool{
//        print(lhs.assetClawback?.bytes)
//        print(rhs.assetClawback?.bytes)
//        print(lhs.assetDecimals)
//        print( rhs.assetDecimals)
//        print(lhs.assetDefaultFrozen)
//        print(rhs.assetDefaultFrozen)
//        print(lhs.assetUnitName)
//        print( rhs.assetUnitName)
//        print(lhs.assetName )
//        print( rhs.assetName)
//        print(lhs.url)
//        print(rhs.url )
//        print(lhs.metadataHash)
//        print(rhs.metadataHash)
//        print(lhs.assetManager)
//        print(rhs.assetManager)
//        print( lhs.assetReserve )
//        print(rhs.assetManager)
//        print(lhs.assetReserve )
//        print(rhs.assetReserve)
//        print(lhs.assetFreeze)
//        print(rhs.assetFreeze)
//        print(lhs.assetClawback)
//        print(rhs.assetClawback)
        
        return    lhs.assetClawback == rhs.assetClawback && lhs.assetDecimals == rhs.assetDecimals && lhs.assetDefaultFrozen == rhs.assetDefaultFrozen && lhs.assetUnitName == rhs.assetUnitName && lhs.assetName == rhs.assetName && lhs.url == rhs.url && lhs.metadataHash == rhs.metadataHash
            && lhs.assetManager == rhs.assetManager && lhs.assetReserve == rhs.assetReserve && lhs.assetFreeze == rhs.assetFreeze && lhs.assetClawback == rhs.assetClawback
    }
    
}
