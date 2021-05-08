//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/8/21.
//

import Foundation
public class ApplicationBaseTransactionBuilder <T>:TransactionBuilder<T>{
    var onCompletion:Transaction.onCompletion?
    var applicationArgs: [[Int8]]?
    var accounts:[Address]?
    var foreignApps:[Int64]?
    var foreignAssets:[Int64]?
    var applicationId:Int64?
    
    
    convenience init() {
        self.init(Transaction.type.ApplicationCall)
    }
    
    /**
         * ApplicationID is the application being interacted with, or 0 if creating a new application.
         */
//        public T applicationId(Long applicationId) {
//            this.applicationId = applicationId;
//            return (T) this;
//        }
    
    public func  applicationId(applicationId: Int64)throws -> T{
        self.applicationId = applicationId
        return self as! T
    }

        /**
         * This is the faux application type used to distinguish different application actions. Specifically, OnCompletion
         * specifies what side effects this transaction will have if it successfully makes it into a block.
         */
//        protected T onCompletion(Transaction.OnCompletion onCompletion) {
//            this.onCompletion = onCompletion;
//            return (T) this;
//        }
    
    func onCompletion(onCompletion:Transaction.onCompletion)->T{
        self.onCompletion=onCompletion
        return self as! T
    }

        /**
         * ApplicationArgs lists some transaction-specific arguments accessible from application logic.
         */
//        public T args(List<byte[]> args) {
//            this.applicationArgs = args;
//            return (T) this;
//        }
    
    func args(args:[[Int8]]) ->T{
        self.applicationArgs = args
        return self as! T
    }

        /**
         * ApplicationArgs lists some transaction-specific arguments accessible from application logic.
         * @param args List of Base64 encoded strings.
         */
//        public T argsBase64Encoded(List<String> args) {
//            List<byte[]> decodedArgs = new ArrayList<>();
//            for (String arg : args) {
//                decodedArgs.add(Encoder.decodeFromBase64(arg));
//            }
//            return this.args(decodedArgs);
//        }
    
   public  func argsBase64Encoded(args:[String])->T{
        var decodedArgs:[[Int8]] = Array()
        for i in 0..<args.count{
            var int8s:[Int8] = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: args[i]))
            decodedArgs.append(int8s)
        }
        return  self.args(args: decodedArgs)
    }

        /**
         * Accounts lists the accounts (in addition to the sender) that may be accessed from the application logic.
         */
//        public T accounts(List<Address> accounts) {
//            this.accounts = accounts;
//            return (T) this;
//        }

    public func accounts(accounts:[Address])->T{
        self.accounts=accounts
        return self as! T
    }
    
        /**
         * ForeignApps lists the applications (in addition to txn.ApplicationID) whose global states may be accessed by this
         * application. The access is read-only.
         */
//        public T foreignApps(List<Long> foreignApps) {
//            this.foreignApps = foreignApps;
//            return (T) this;
//        }
    
    public func foreignApps(foreignApps:[Int64])->T{
        self.foreignApps = foreignApps
        return self as! T
    }

        /**
         * ForeignAssets lists the assets whose global states may be accessed by this
         * application. The access is read-only.
         */
//        public T foreignAssets(List<Long> foreignAssets) {
//            this.foreignAssets = foreignAssets;
//            return (T) this;
//        }
    
    public func foreignAssets(foreignAssets:[Int64])->T{
        self.foreignAssets = foreignAssets
        return self as! T
    }
}
