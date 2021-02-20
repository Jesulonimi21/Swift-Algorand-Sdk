//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/16/21.
//

import Foundation

public class AssetFreezeTransactionBuilder: TransactionBuilder<AssetFreezeTransactionBuilder> {
    var freezeTarget:Address? = nil;
    var assetIndex:Int64? = nil;
    var freezeState = false;



    convenience init() {
        self.init(Transaction.type.AssetFreeze);
    }

    override func applyTo(_ txn:Transaction) {
//        Objects.requireNonNull(this.assetIndex, "assetIndex is required.");
//        Objects.requireNonNull(this.freezeState, "freezeState is required.");

    if let freezeTarget=self.freezeTarget{
        txn.freezeTarget=self.freezeTarget
    }
       
        
        if let assetIndex=self.assetIndex{
            txn.assetFreezeID=assetIndex
        }
        

        txn.freezeState = self.freezeState;
    }

    internal func freezeTarget(freezeTarget:Address)->AssetFreezeTransactionBuilder {
        self.freezeTarget = freezeTarget;
        return self;
    }

//    public T freezeTarget(String freezeTarget) {
//        try {
//            this.freezeTarget = new Address(freezeTarget);
//            return this;
//        } catch (NoSuchAlgorithmException var3) {
//            throw new IllegalArgumentException(var3);
//        }
//    }
//
//    public T freezeTarget(byte[] freezeTarget) {
//        this.freezeTarget = new Address(freezeTarget);
//        return this;
//    }

    public func assetIndex(assetIndex:Int64)->AssetFreezeTransactionBuilder {
        self.assetIndex = assetIndex;
        return self;
    }

//    public T assetIndex(Integer assetIndex) {
//        if (assetIndex < 0) {
//            throw new IllegalArgumentException("assetIndex cannot be a negative value");
//        } else {
//            this.assetIndex = BigInteger.valueOf((long)assetIndex);
//            return this;
//        }
//    }
//
//    public T assetIndex(Long assetIndex) {
//        if (assetIndex < 0L) {
//            throw new IllegalArgumentException("assetIndex cannot be a negative value");
//        } else {
//            this.assetIndex = BigInteger.valueOf(assetIndex);
//            return this;
//        }
//    }

    public func freezeState(freezeState:Bool)-> AssetFreezeTransactionBuilder {
        self.freezeState = freezeState;
        return self;
    }
}
