//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/15/21.
//

import Foundation

public class AssetTransferTransactionBuilder : TransactionBuilder<AssetTransferTransactionBuilder> {
    var assetReceiver:Address? = nil;
    var assetCloseTo:Address? = nil;
    var assetAmount:Int64? = nil;
    var assetIndex:Int64? = nil;

  
   convenience init() {
    self.init(Transaction.type.AssetTransfer);
    }

    override func applyTo(_ txn:Transaction) {
//        Objects.requireNonNull(this.assetIndex, "assetIndex is required.");
//        Objects.requireNonNull(this.assetReceiver, "assetReceiver is required.");
//        Objects.requireNonNull(this.assetAmount, "assetAmount is required.");
        if let assetReceiver=self.assetReceiver{
            txn.assetReceiver=assetReceiver
        }

        if let assetCloseTo=self.assetCloseTo{
            txn.assetCloseTo=assetCloseTo
        }
        if let assetAmount=self.assetAmount{
            txn.assetAmount=assetAmount
        }
        if let assetIndex=self.assetIndex{
            txn.xferAsset=assetIndex
        }

    }

    internal func assetReceiver(assetReceiver:Address)->AssetTransferTransactionBuilder {
        self.assetReceiver = assetReceiver;
        return self;
    }

//    public func assetReceiver(String assetReceiver) {
//        try {
//            this.assetReceiver = new Address(assetReceiver);
//            return this;
//        } catch (NoSuchAlgorithmException var3) {
//            throw new IllegalArgumentException(var3);
//        }
//    }
//
//    public func assetReceiver(byte[] assetReceiver) {
//        this.assetReceiver = new Address(assetReceiver);
//        return this;
//    }

    internal func assetCloseTo(assetCloseTo:Address)->AssetTransferTransactionBuilder {
        self.assetCloseTo = assetCloseTo;
        return self;
    }


    public func assetIndex(assetIndex:Int64)->AssetTransferTransactionBuilder {
        self.assetIndex = assetIndex;
        return self;
    }


    public func assetAmount(assetAmount:Int64) -> AssetTransferTransactionBuilder{
        self.assetAmount = assetAmount;
        return self;
    }
}
