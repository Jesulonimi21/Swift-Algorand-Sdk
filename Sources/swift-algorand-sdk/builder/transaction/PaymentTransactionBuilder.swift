//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/5/21.
//

import Foundation
public class PaymentTransactionBuilder : TransactionBuilder<PaymentTransactionBuilder> {
    var amount:Int64? = nil;
    var receiver:Address? = nil;
    var closeRemainderTo:Address? = nil;

    public static func Builder() -> PaymentTransactionBuilder{
        return  PaymentTransactionBuilder();
    }

       convenience init() {
            self.init(Transaction.type.Payment);
            }

    override  func  applyTo(_ txn:Transaction) throws{
        if (self.sender == nil && self.closeRemainderTo == nil) {
            throw  Errors.illegalArgumentError("Must set at least one of 'receiver' or 'closeRemainderTo'")
        } else {

            if (self.amount != nil) {
                txn.amount = self.amount;
            }

            if (self.receiver != nil) {
                txn.receiver = self.receiver!;
            }

            if (self.closeRemainderTo != nil) {
                txn.closeRemainderTo = self.closeRemainderTo;
            }

        }
    }

        public func amount(_ amount: Int64) -> PaymentTransactionBuilder{
        self.amount = amount;
        return self;
    }

        public func  amount(amount: Int64)throws -> PaymentTransactionBuilder{
        if (amount < 0) {
            throw Errors.illegalArgumentError("amount cannot be a negative value");
        print("amount cannot be a negative value")
        } else {
            self.amount = amount;
            return self;
        }
            return self;
    }

        internal func receiver(_ receiver:Address) -> PaymentTransactionBuilder{
        self.receiver = receiver;
        return self;
    }


        public func receiver(_ receiver:[Int8]) -> PaymentTransactionBuilder{
        self.receiver =  try! Address(receiver);
        return self;
    }

     func  closeRemainderTo (_ closeRemainderTo:Address) -> PaymentTransactionBuilder {
        self.closeRemainderTo = closeRemainderTo;
            return self ;
    }


     func closeRemainderTo (_ closeRemainderTo:[Int8]) -> PaymentTransactionBuilder{
        self.closeRemainderTo = try!  Address(closeRemainderTo);
        return self;
    }
}
    
