//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/8/21.
//

import Foundation

public class ApplicationUpdateTransactionBaseBuilder <T> : ApplicationBaseTransactionBuilder<T>{

    public var approvalProgram:TEALProgram?
    public var clearStateProgram:TEALProgram?
    
    
    
   convenience init(){
        self.init(Transaction.type.ApplicationCall);
        self.onCompletion(onCompletion: Transaction.onCompletion.UpdateApplicationOC)
    }


    override func applyTo(_ txn: Transaction) throws {
        txn.clearStateProgram = clearStateProgram
        txn.approvalProgram = approvalProgram
        
     try   super.applyTo(txn)
    }
  

    /**
     * ApprovalProgram determines whether or not this ApplicationCall transaction will be approved or not.
     */


    public func approvalProgram(approvalProgram:TEALProgram)->T{
        self.approvalProgram = approvalProgram
        return self as! T
    }
    /**
     * ClearStateProgram executes when a clear state ApplicationCall transaction is executed. This program may not
     * reject the transaction, only update state.
     */

    
    public func clearStateProgram (clearStateProgram:TEALProgram)->T{
        self.clearStateProgram = clearStateProgram
        return self as! T
    }
}
