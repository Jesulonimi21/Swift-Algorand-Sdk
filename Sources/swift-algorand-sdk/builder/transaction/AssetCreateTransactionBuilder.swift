//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/12/21.
//

import Foundation

public class AssetCreateTransactionBuilder: TransactionBuilder<AssetCreateTransactionBuilder> {
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

//    public static AssetCreateTransactionBuilder<?> Builder() {
//        return  AssetCreateTransactionBuilder();
//    }

       convenience init() {
        self.init(Transaction.type.AssetConfig);
    }

    convenience init(type:Transaction.type) {
        self.init(type);
    }

    override func applyTo(_ txn:Transaction) {
        guard let  params = try?  AssetParams(assetTotal: self.assetTotal, assetDecimals: self.assetDecimals ?? 0, assetDefaultFrozen: self.defaultFrozen ?? false, assetUnitName: self.assetUnitName, assetName: self.assetName, url: self.url, metadataHash: self.metadataHash, assetManager: self.manager, assetReserve: self.reserve, assetFreeze: self.freeze, assetClawback: self.clawback) else {
            txn.assetParams = nil
            return
        }
        
        txn.assetParams = params;

    }

    public func setAssetTotal(assetTotal:Int64) ->AssetCreateTransactionBuilder{
        self.assetTotal = assetTotal;
        return self;
    }


    public func setAssetDecimals(assetDecimals:Int64)->AssetCreateTransactionBuilder {
        self.assetDecimals = assetDecimals;
        return self;
    }

    public func defaultFrozen(defaultFrozen:Bool)->AssetCreateTransactionBuilder {
        self.defaultFrozen = defaultFrozen;
        return self;
    }

    public func assetUnitName(assetUnitName:String)->AssetCreateTransactionBuilder {
        self.assetUnitName = assetUnitName;
        return self;
    }

    public func assetName(assetName:String)->AssetCreateTransactionBuilder {
        self.assetName = assetName;
        return self;
    }

    public func url(url:String)->AssetCreateTransactionBuilder {
        self.url = url;
        return self;
    }

    public func metadataHash(metadataHash:[Int8])->AssetCreateTransactionBuilder {
        self.metadataHash = metadataHash;
        return self;
    }

    public func metadataHashUTF8(metadataHash:String)->AssetCreateTransactionBuilder {
        self.metadataHash = CustomEncoder.convertToInt8Array(input: metadataHash.bytes);
        return self;
    }

    public func metadataHashB64(metadataHash:String)->AssetCreateTransactionBuilder {
        self.metadataHash = CustomEncoder.convertToInt8Array(input: Array(CustomEncoder.decodeFromBase64(metadataHash.bytes)))
        return self;
    }

    public func manager(manager:Address)->AssetCreateTransactionBuilder {
        self.manager = manager;
        return self;
    }

    public func manager(manager:String)->AssetCreateTransactionBuilder {
        guard let Umanager = try? Address(manager) else {
            return self
        }
        self.manager = Umanager
            return self;
       
    }

    public func manager(manager:[Int8])->AssetCreateTransactionBuilder {
        guard let Umanager = try? Address(manager) else {
            return self
        }
        self.manager = Umanager
        return self;
    }

    public func reserve(reserve:Address)->AssetCreateTransactionBuilder {
        self.reserve = reserve;
        return self;
    }

    public func reserve(reserve:String)->AssetCreateTransactionBuilder {
       
        guard let UReserve = try? Address(reserve) else {
            return self
        }
        self.reserve = UReserve
            return self;
        
    }

    public func reserve(reserve:[Int8])->AssetCreateTransactionBuilder {
        guard let UReserve = try? Address(reserve) else {
            return self
        }
        self.reserve = UReserve
        return self;
    }

    public func freeze(freeze:Address)->AssetCreateTransactionBuilder {
        self.freeze = freeze;
        return self;
    }

    public func freeze(freeze:String)->AssetCreateTransactionBuilder {
       
        guard let UFreeze = try? Address(freeze) else {
            return self
        }
        self.freeze = UFreeze
            return self;
    }

    public func freeze(freeze:[Int8])->AssetCreateTransactionBuilder {
        guard let UFreeze = try? Address(freeze) else {
            return self
        }
        self.freeze = UFreeze
        return self;
    }

    public func clawback(clawback:Address)->AssetCreateTransactionBuilder {
        self.clawback = clawback;
        return self;
    }

    public func clawback(clawback:String)->AssetCreateTransactionBuilder {
    
        guard let UClawback = try? Address(clawback) else {
            return self
        }
        self.clawback = UClawback
            return self;
    }

    public func clawback(clawback:[Int8])->AssetCreateTransactionBuilder {
        guard let UClawback = try? Address(clawback) else {
            return self
        }
        self.clawback = UClawback
        return self;
    }
}
