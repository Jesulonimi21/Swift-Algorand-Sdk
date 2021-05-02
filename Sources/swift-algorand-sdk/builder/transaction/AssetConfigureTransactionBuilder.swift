//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/13/21.
//

import Foundation
public class AssetConfigureTransactionBuilder:BaseAssetBuilder<AssetConfigureTransactionBuilder>{
    
    var  assetIndex:Int64? = nil;
    var strictEmptyAddressChecking = true;

      

        convenience init() {
        self.init(type:Transaction.type.AssetConfig);
       }

override func applyTo(_ txn:Transaction) throws {
    
           if (self.assetUnitName != nil) {
               throw Errors.illegalArgumentError("Must not set assetUnitName.");
           } else if (self.assetName != nil) {
            throw Errors.illegalArgumentError("Must not set assetName.");
           } else if (self.url != nil) {
            throw Errors.illegalArgumentError("Must not set url.");
           } else if (self.metadataHash != nil) {
            throw Errors.illegalArgumentError("Must not set metadataHash.");
           } else if (self.assetDecimals != nil) {
            throw Errors.illegalArgumentError("Must not set assetDecimals.");
           } else if (self.assetTotal != nil) {
            throw Errors.illegalArgumentError("Must not set assetTotal.");
           } else if (self.defaultFrozen) {
            throw Errors.illegalArgumentError("Must not set defaultFrozen.");
           }
//    else {
               var  defaultAddr =  Address();
//               if (this.strictEmptyAddressChecking && (this.manager == nil || this.manager.equals(defaultAddr) || this.reserve == null || this.reserve.equals(defaultAddr) || this.freeze == null || this.freeze.equals(defaultAddr) || this.clawback == null || this.clawback.equals(defaultAddr)))
    if(self.clawback==nil || self.clawback == defaultAddr || self.manager==nil || self.manager == defaultAddr || self.reserve == nil || self.reserve == defaultAddr || self.freeze == nil || self.freeze == defaultAddr)
               {
        throw Errors.runtimeError("strict empty address checking requested but empty or default address supplied to one or more manager addresses");
               }
//        else {
        if let assetIndex=self.assetIndex {
                           txn.assetIndex = self.assetIndex;
                       }

                 try  super.applyTo(txn);
               }
//           }
       
       public func assetIndex(assetIndex:Int64?)->AssetConfigureTransactionBuilder {
           self.assetIndex = assetIndex;
           return self;
       }

public func strictEmptyAddressChecking(strictEmptyAddressChecking:Bool)->AssetConfigureTransactionBuilder {
           self.strictEmptyAddressChecking = strictEmptyAddressChecking;
           return self
       }
       
       
   }

       

