//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/5/21.
//

import Foundation
public extension StringProtocol {
    public var data: Data { .init(utf8) }
    public var bytes: [UInt8] { .init(utf8) }
    
   
}
public extension StringProtocol where Self: RangeReplaceableCollection {
  public  var removingAllWhitespaces: Self {
        filter(\.isWhitespace.negated)
    }
    public mutating func removeAllWhitespaces() {
        removeAll(where: \.isWhitespace)
    }
}
extension Bool {
    var negated: Bool { !self }
}
public  class TransactionBuilder<T>{
    var type:String?=nil;
    var sender:Address? = nil;
    var fee:Int64? = nil;
    var flatFee:Int64? = nil;
    var firstValid:Int64? = nil;
    var lastValid:Int64? = nil;
    var note:[Int8]? = nil;
    var  lease:[Int8]? = nil;
    var rekeyTo:Address? = nil;
    var  genesisID:String? = nil;
    var genesisHash:Digest? = nil;
    var group:Digest? = nil;

    init(_ type: Transaction.type) {
        self.type = type.rawValue;
    }

     func  applyTo(_ var1: Transaction) throws{};

     public func build() throws ->Transaction{
        if (self.lastValid == nil && self.firstValid != nil) {
            self.lastValid = self.firstValid!+1000;
        }

        var txn =  Transaction()
        txn.type = self.type!
      try  self.applyTo(txn);
        if (self.sender != nil) {
            txn.sender = self.sender!;
        }

        if (self.firstValid != nil) {
            txn.firstValid = self.firstValid!;
        }

        if (self.lastValid != nil) {
            txn.lastValid = self.lastValid;
        }

        
        if let uNote = self.note {
            if(uNote.count>0){
                txn.note = self.note;
            }
            
        }

        if (self.rekeyTo != nil) {
            txn.rekeyTo = self.rekeyTo;
        }

        if (self.genesisID != nil) {
            txn.genesisID = self.genesisID;
        }

        if (self.genesisHash != nil) {
            txn.genesisHash = self.genesisHash;
        }

        if (self.lease != nil && self.lease!.count != 0) {
            txn.setLease(lease: try Lease(lease: self.lease!));
        }

        if (self.fee != nil && self.flatFee != nil) {
            throw Errors.illegalArgumentError("Cannot set both fee and flatFee.")
        } else {
            if (self.fee != nil) {
               try! Account.setFeeByFeePerByte(tx: txn, suggestedFeePerByte: fee!)
            }

            if (self.flatFee != nil) {
                txn.fee = self.flatFee;
            }

            if (txn.fee == nil || txn.fee == 0) {
                txn.fee = Account.MIN_TX_FEE_UALGOS;
            }

            return txn;
        }
        return txn;
    }

    public func fee(_ fee:Int64)->T {
        self.fee = fee;
        return self as! T;
    }
    public func flatFee(_ flatFee:Int64)->T {
        self.flatFee = flatFee;
        return self as! T;
    }
    public func suggestedParams(params:TransactionParametersResponse) ->T{
        self.fee(params.fee!);
        self.genesisID(params.genesisId!);
        self.genesisHash(params.genesisHash!);
        self.firstValid(params.lastRound!);
        self.lastValid(params.lastRound! + 1000);
        return self as! T;
    }
//
    public func   setSender (_ sender:Address) -> T {
        self.sender = sender;
        return self as! T;
    }
    
    public func genesisID(_ ID:String)->T{
        self.genesisID=ID
        return self as! T;
    }

    public func  firstValid(_ firstValid:Int64) -> T{
        self.firstValid = firstValid;
        return self as! T;
    }

//
    public func lastValid(_ lastValid:Int64)->T {
        self.lastValid = lastValid;
        return self as! T;
    }

    public func note(_ note:[Int8])->T {
        self.note = note;
        return self as! T;
    }
    
    public func noteB64(note:String)->T {
        self.note=CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: note))
        
        return  self as! T;
       }
    
    public func note(_ note:[UInt8])->T {
        self.note = CustomEncoder.convertToInt8Array(input: note);
        return self as! T;
    }

    public func genesisHash(_ genesisHash:[Int8]) -> T{
        self.genesisHash =  Digest(genesisHash);
        return self as! T;
    }
    public func genesisHash(_ genesisHash:Digest) -> T{
        self.genesisHash =  genesisHash;
        return self as! T;
    }
    
    public func lease(lease:[Int8]) -> T{
           self.lease = lease
        return self as! T
       }
    
    public func leaseB64(lease:String) -> T{
        self.lease = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: lease))
        return self as! T
    }
    public func genesisHashB64(_ genesisHash:String)-> T{
        self.genesisHash = Digest(  CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: genesisHash)))
        return self as! T
    }
    
    public func rekey(rekeyTo:Address) -> T {
          self.rekeyTo = rekeyTo;
        return self as! T
      }
    
    


//Group,rekey,flatFee, try setFeePerByte
}
