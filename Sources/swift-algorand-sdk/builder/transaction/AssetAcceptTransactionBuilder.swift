//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/15/21.
//

import Foundation


public class AssetAcceptTransactionBuilder: TransactionBuilder<AssetAcceptTransactionBuilder> {
    var  assetIndex:Int64? = nil;
    
    
    
    convenience init() {
        self.init(Transaction.type.AssetTransfer);
    }

    override func applyTo(_ txn:Transaction) {
//        Objects.requireNonNull(this.assetIndex, "assetIndex is required");
//        Objects.requireNonNull(this.sender, "acceptingAccount is required");
    if let assetIndex=self.assetIndex {
                       txn.xferAsset = self.assetIndex;
                   }

    if let sender=self.sender {
                       txn.assetReceiver = self.sender;
       }


//        txn.amount = 0;
    }

    internal func acceptingAccount(acceptingAccount:Address)->AssetAcceptTransactionBuilder {
        self.sender = acceptingAccount;
        return self;
    }

//    public T acceptingAccount(String acceptingAccount) {
//        try {
//            this.sender = new Address(acceptingAccount);
//            return this;
//        } catch (NoSuchAlgorithmException var3) {
//            throw new IllegalArgumentException(var3);
//        }
//    }
//
//    public T acceptingAccount(byte[] acceptingAccount) {
//        this.sender = new Address(acceptingAccount);
//        return this;
//    }

    public func assetIndex(assetIndex:Int64?)->AssetAcceptTransactionBuilder {
        self.assetIndex = assetIndex;
        return self;
    }
}
