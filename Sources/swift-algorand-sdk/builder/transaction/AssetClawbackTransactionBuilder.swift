//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/16/21.
//

import Foundation


public class AssetClawbackTransactionBuilder: TransactionBuilder<AssetClawbackTransactionBuilder> {
    var assetClawbackFrom:Address? = nil;
    var assetReceiver:Address? = nil;
    var  assetCloseTo:Address? = nil;
    var assetAmount:Int64? = nil;
    var assetIndex:Int64? = nil;

  

     convenience init() {
        self.init(Transaction.type.AssetTransfer);
    }

    override func applyTo(_ txn:Transaction) {
//        Objects.requireNonNull(this.sender, "sender is required.");
//        Objects.requireNonNull(this.assetClawbackFrom, "assetClawbackFrom is required.");
//        Objects.requireNonNull(this.assetReceiver, "assetReceiver is required.");
//        Objects.requireNonNull(this.assetAmount, "assetAmount is required.");
//        Objects.requireNonNull(this.firstValid, "firstValid is required.");
//        Objects.requireNonNull(this.lastValid, "lastValid is required.");
//        Objects.requireNonNull(this.genesisHash, "genesisHash is required.");
     
        if let assetClawbackFrom=self.assetClawbackFrom{
            txn.assetSender=assetClawbackFrom
        }
        
        if let assetReceiver=self.assetReceiver{
            txn.assetReceiver = assetReceiver
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

    internal func assetClawbackFrom(assetClawbackFrom:Address)->AssetClawbackTransactionBuilder {
        self.assetClawbackFrom = assetClawbackFrom;
        return self;
    }
//
//    public T assetClawbackFrom(String assetClawbackFrom) {
//        try {
//            this.assetClawbackFrom = new Address(assetClawbackFrom);
//            return this;
//        } catch (NoSuchAlgorithmException var3) {
//            throw new IllegalArgumentException(var3);
//        }
//    }
//
//    public T assetClawbackFrom(byte[] assetClawbackFrom) {
//        this.assetClawbackFrom = new Address(assetClawbackFrom);
//        return this;
//    }

    internal func assetReceiver(assetReceiver:Address)->AssetClawbackTransactionBuilder {
        self.assetReceiver = assetReceiver;
        return self;
    }

//    public T assetReceiver(String assetReceiver) {
//        try {
//            this.assetReceiver = new Address(assetReceiver);
//            return this;
//        } catch (NoSuchAlgorithmException var3) {
//            throw new IllegalArgumentException(var3);
//        }
//    }
//
//    public T assetReceiver(byte[] assetReceiver) {
//        this.assetReceiver = new Address(assetReceiver);
//        return this;
//    }

    internal func assetCloseTo(assetCloseTo:Address)->AssetClawbackTransactionBuilder {
        self.assetCloseTo = assetCloseTo;
        return self;
    }

//    public func assetCloseTo(String assetCloseTo) {
//        try {
//            this.assetCloseTo = new Address(assetCloseTo);
//            return this;
//        } catch (NoSuchAlgorithmException var3) {
//            throw new IllegalArgumentException(var3);
//        }
//    }
//
//    public T assetCloseTo(byte[] assetCloseTo) {
//        this.assetCloseTo = new Address(assetCloseTo);
//        return this;
//    }

    internal func assetIndex(assetIndex:Int64) ->AssetClawbackTransactionBuilder{
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

    internal func assetAmount(assetAmount:Int64) ->AssetClawbackTransactionBuilder{
        self.assetAmount = assetAmount;
        return self;
    }

//    public T assetAmount(Integer assetAmount) {
//        if (assetAmount < 0) {
//            throw new IllegalArgumentException("assetAmount cannot be a negative value");
//        } else {
//            this.assetAmount = BigInteger.valueOf((long)assetAmount);
//            return this;
//        }
//    }
//
//    public T assetAmount(Long assetAmount) {
//        if (assetAmount < 0L) {
//            throw new IllegalArgumentException("assetAmount cannot be a negative value");
//        } else {
//            this.assetAmount = BigInteger.valueOf(assetAmount);
//            return this;
//        }
//    }
}
