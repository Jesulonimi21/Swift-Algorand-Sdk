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

override func applyTo(_ txn:Transaction) {
//           if (this.assetUnitName != null) {
//               throw new IllegalArgumentException("Must not set assetUnitName.");
//           } else if (this.assetName != null) {
//               throw new IllegalArgumentException("Must not set assetName.");
//           } else if (this.url != null) {
//               throw new IllegalArgumentException("Must not set url.");
//           } else if (this.metadataHash != null) {
//               throw new IllegalArgumentException("Must not set metadataHash.");
//           } else if (this.assetDecimals != null) {
//               throw new IllegalArgumentException("Must not set assetDecimals.");
//           } else if (this.assetTotal != null) {
//               throw new IllegalArgumentException("Must not set assetTotal.");
//           } else if (this.defaultFrozen) {
//               throw new IllegalArgumentException("Must not set defaultFrozen.");
//           } else {
//               Address defaultAddr = new Address();
//               if (this.strictEmptyAddressChecking && (this.manager == null || this.manager.equals(defaultAddr) || this.reserve == null || this.reserve.equals(defaultAddr) || this.freeze == null || this.freeze.equals(defaultAddr) || this.clawback == null || this.clawback.equals(defaultAddr))) {
//                   throw new RuntimeException("strict empty address checking requested but empty or default address supplied to one or more manager addresses");
//               } else {
        if let assetIndex=self.assetIndex {
                           txn.assetIndex = self.assetIndex;
                       }

                   super.applyTo(txn);
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

       

