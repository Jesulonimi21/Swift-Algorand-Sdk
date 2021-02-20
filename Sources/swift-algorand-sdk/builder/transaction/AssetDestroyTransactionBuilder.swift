//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/15/21.
//

import Foundation

public class AssetDestroyTransactionBuilder: TransactionBuilder<AssetDestroyTransactionBuilder> {
    var  assetIndex:Int64? = nil;

 
    convenience init() {
        self.init(Transaction.type.AssetConfig);
        
    }

    override func applyTo(_ txn:Transaction) {
//        Objects.requireNonNull(this.assetIndex, "assetIndex is required.");
    if let assetIndex=self.assetIndex {
                       txn.assetIndex = self.assetIndex;
                   }

    }

    

    public func assetIndex(assetIndex:Int64?)->AssetDestroyTransactionBuilder {
        self.assetIndex = assetIndex;
        return self;
    }

}
