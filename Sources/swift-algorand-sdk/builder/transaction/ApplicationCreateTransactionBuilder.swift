//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/8/21.
//

import Foundation
public class ApplicationCreateTransactionBuilder : ApplicationUpdateTransactionBaseBuilder<ApplicationCreateTransactionBuilder> {
    private var localStateSchema: StateSchema?
    private var globalStateSchema: StateSchema?

    /**
     * Initialize a {@link ApplicationCreateTransactionBuilder}.
     */
   
    convenience init(){
        self.init(Transaction.type.ApplicationCall)
        self.onCompletion(onCompletion: Transaction.onCompletion.NoOpOC)
    }


    
    override func applyTo(_ txn: Transaction) throws {
        txn.localStateSchema = localStateSchema
        txn.globalStateSchema = globalStateSchema
        
      try  super.applyTo(txn)
    }
    


    /**
     * This option is disabled for application create, where the ID must be changed from 0.
     */
    
    
    public override func applicationId(applicationId: Int64)throws -> ApplicationCreateTransactionBuilder{
        if applicationId != 0{
            throw Errors.illegalArgumentError("Application ID must be zero, do not set this for application create.")
        }
        return self as! ApplicationCreateTransactionBuilder
    }


    /**
     * When creating an application, you have the option of opting in with the same transaction. Without this flag a
     * separate transaction is needed to opt-in.
     */

    
    public func optIn(optIn:Bool)-> ApplicationCreateTransactionBuilder{
        if optIn{
            super.onCompletion(onCompletion: Transaction.onCompletion.OptInOC)
        }else{
            super.onCompletion(onCompletion: Transaction.onCompletion.NoOpOC)
        }
        return self as! ApplicationCreateTransactionBuilder
        
    }

    /**
     * LocalStateSchema sets limits on the number of strings and integers that may be stored in an account's LocalState.
     * for this application. The larger these limits are, the larger minimum balance must be maintained inside the
     * account of any users who opt into this application. The LocalStateSchema is immutable.
     */

    
    public func localStateSchema(localStateSchema:StateSchema)->ApplicationCreateTransactionBuilder{
        self.localStateSchema = localStateSchema
        return self as! ApplicationCreateTransactionBuilder
    }
    
    

    /**
     * GlobalStateSchema sets limits on the number of strings and integers that may be stored in the GlobalState. The
     * larger these limits are, the larger minimum balance must be maintained inside the creator's account (in order to
     * 'pay' for the state that can be used). The GlobalStateSchema is immutable.
     */

    public func globalStateSchema (globalStateSchema:StateSchema) ->ApplicationCreateTransactionBuilder{
        self.globalStateSchema = globalStateSchema
        return self as! ApplicationCreateTransactionBuilder
    }
}
