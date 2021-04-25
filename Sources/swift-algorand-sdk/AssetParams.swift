//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/6/21.
//

import Foundation
public class AssetParams: Codable,Equatable {
    internal init(assetTotal: Int64?, assetDecimals: Int64?, assetDefaultFrozen: Bool?, assetUnitName: String?, assetName: String?, url: String? , metadataHash: [Int8]?, assetManager: Address? , assetReserve: Address?, assetFreeze: Address?, assetClawback: Address? ) {
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
    
    var assetTotal:Int64?
    var assetDecimals:Int64?
    var assetDefaultFrozen:Bool?
    var assetUnitName:String?
    var assetName:String?;
    var url:String?;
    var metadataHash:[Int8]?;
    var assetManager:Address?
    var  assetReserve:Address?;
    var assetFreeze:Address?;
    var assetClawback:Address?;
    
    
 
    
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
    
    public static func == (lhs:AssetParams,rhs:AssetParams)->Bool{
        var assetTotal:Int64?
        var assetDecimals:Int64?
        var assetDefaultFrozen:Bool?
        var assetUnitName:String?
        var assetName:String?;
        var url:String?;
        var metadataHash:[Int8]?;
        var assetManager:Address?
        var  assetReserve:Address?;
        var assetFreeze:Address?;
        var assetClawback:Address?;
        return    lhs.assetClawback == rhs.assetClawback && lhs.assetDecimals == rhs.assetDecimals && lhs.assetDefaultFrozen == rhs.assetDefaultFrozen && lhs.assetUnitName == rhs.assetUnitName && lhs.assetName == rhs.assetName && lhs.url == rhs.url && lhs.metadataHash == rhs.metadataHash
            && lhs.assetManager == rhs.assetManager && lhs.assetReserve == rhs.assetReserve && lhs.assetFreeze == rhs.assetFreeze && lhs.assetClawback == rhs.assetClawback
    }
    
}
