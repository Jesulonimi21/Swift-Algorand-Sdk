//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/15/21.
//

import Foundation

public class  BaseAssetBuilder <T>: TransactionBuilder<BaseAssetBuilder> {
    var assetTotal:Int64? = nil;
    var assetDecimals:Int64? = nil;
    var  defaultFrozen:Bool = false;
    var  assetUnitName: String?=nil;
    var assetName:String? = nil;
    var url:String? = nil;
    var metadataHash:[Int8]? = nil;
    var manager:Address? = nil;
    var reserve:Address? = nil;
    var freeze:Address? = nil;
    var clawback:Address? = nil;


       convenience init() {
        self.init(Transaction.type.AssetConfig);
    }

    convenience init(type:Transaction.type) {
        self.init(type);
    }

    override func applyTo(_ txn:Transaction) {
     
//Use a gard statement to make sure sender,firstvalid,lastvalid,genesishash,assetTotal.assetDecimals have a value
    
    
        var params =  AssetParams(assetTotal: self.assetTotal, assetDecimals: self.assetDecimals ?? 0, assetDefaultFrozen: self.defaultFrozen ?? false, assetUnitName: self.assetUnitName, assetName: self.assetName, url: self.url, metadataHash: self.metadataHash, assetManager: self.manager, assetReserve: self.reserve, assetFreeze: self.freeze, assetClawback: self.clawback);
        
        txn.assetParams = params;
        print(txn.assetParams?.assetDecimals)
        print("Assset ffrozen")
    }

    public func setAssetTotal(assetTotal:Int64) ->T{
        self.assetTotal = assetTotal;
        return self as! T;
    }

//    public func setAssetTotal(assetTotal:Int64)throws ->T {
//        if (assetTotal < 0) {
//            throw Errors.illegalArgumentError("assetTotal cannot be a negative value");
//        } else {
//            self.assetTotal = assetTotal;
//            return self as! T;
//        }
//    }
//
//    public func setAssetTotal(assetTotal:Int64) throws->T{
//        if assetTotal < 0{
//            throw Errors.illegalArgumentError("assetTotal cannot be a negative value");
//        } else {
//            self.assetTotal = assetTotal;
//            return self as! T;
//        }
//    }

    public func setAssetDecimals(assetDecimals:Int64)->T {
        self.assetDecimals = assetDecimals;
        return self as! T;
    }

    public func defaultFrozen(defaultFrozen:Bool)->T {
        self.defaultFrozen = defaultFrozen;
        return self as! T;
    }

    public func assetUnitName(assetUnitName:String)->T {
        self.assetUnitName = assetUnitName;
        return self as! T;
    }

    public func assetName(assetName:String)->T {
        self.assetName = assetName;
        return self as! T;
    }

    public func url(url:String)->T {
        self.url = url;
        return self as! T;
    }

    public func metadataHash(metadataHash:[Int8])->T {
        self.metadataHash = metadataHash;
        return self as! T;
    }

    public func metadataHashUTF8(metadataHash:String)->T {
        self.metadataHash = CustomEncoder.convertToInt8Array(input: metadataHash.bytes);
        return self as! T;
    }

    public func metadataHashB64(metadataHash:String)->T {
        self.metadataHash = CustomEncoder.convertToInt8Array(input: Array(CustomEncoder.decodeFromBase64(metadataHash.bytes)))
        return self as! T;
    }

    public func manager(manager:Address)->T {
        self.manager = manager;
        return self as! T;
    }

    public func manager(manager:String)->T {
      
        self.manager =  try! Address(manager);
            return self as! T;
       
    }

    public func manager(manager:[Int8])->T {
        self.manager =  try! Address(manager);
        return self as! T;
    }

    public func reserve(reserve:Address)->T {
        self.reserve = reserve;
        return self as! T;
    }

    public func reserve(reserve:String)->T {
       
        self.reserve =  try! Address(reserve);
            return self as! T;
        
    }

    public func reserve(reserve:[Int8])->T {
        self.reserve =  try! Address(reserve);
        return self as! T;
    }

    public func freeze(freeze:Address)->T {
        self.freeze = freeze;
        return self as! T;
    }

    public func freeze(freeze:String)->T {
       
        self.freeze =  try! Address(freeze);
            return self as! T;
    }

    public func freeze(freeze:[Int8])->T {
        self.freeze =  try! Address(freeze);
        return self as! T;
    }

    public func clawback(clawback:Address)->T {
        self.clawback = clawback;
        return self as! T;
    }

    public func clawback(clawback:String)->T {
    
        self.clawback =  try! Address(clawback);
            return self as! T;
    }

    public func clawback(clawback:[Int8])->T {
        self.clawback =  try! Address(clawback);
        return self as! T;
    }
}
