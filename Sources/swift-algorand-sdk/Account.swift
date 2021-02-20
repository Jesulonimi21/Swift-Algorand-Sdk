//
//  File.swift
//  
//
//  Created by Jesulonimi on 1/30/21.
//
import Ed25519
import CryptoKit
import Foundation




public class Account{
    var address:Address
    var keyPair:KeyPair
    var seed:Seed?
    static var MIN_TX_FEE_UALGOS:Int64 = 1000
    convenience init() throws{
      try  self.init(nil)
    }
    
    init(_ bytes:[Int8]?) throws {
   
        if  let Ubytes = bytes{
             seed = try Seed(bytes:Ubytes.map{Int8val -> UInt8 in
                return unsafeBitCast(Int8val, to: UInt8.self)
            })
        }else{
            seed = try Seed()
        }
       
        self.keyPair = KeyPair(seed: seed!)
      
        let ed25519PubKey = keyPair.publicKey.bytes.map{(UInt8bytes) -> Int8 in
            return unsafeBitCast(UInt8bytes, to: Int8.self)
        }
        self.address=try! Address(ed25519PubKey)
    }
    convenience init( _ mnemonic:String) throws{
      try  self.init(Mnemonic.toKey(mnemonic))
    }
    
    
    
    func getAddress() -> Address{
        return self.address
    }
    
    func toMnemonic() ->String{
        if let Useed=seed{
            var int8Bytes=Useed.bytes.map{(uint8Byts) in
                return unsafeBitCast(uint8Byts, to: Int8.self)}
            return try! Mnemonic.fromKey(int8Bytes)
        }
        return "An error occurred"
      
    }
    
    func signTransaction(tx:Transaction) -> SignedTransaction{
        var txBytes = tx.bytesToSign()
        var testVal:[Int8]=[
            84,88,-120,-93,97,109,116,10,-93,102,101,101,-51,3,-24,-94,102,118,-51,3,-24,-94,103,104,-60,32,72,99,-75,24,-92,-77,-56,78,-56,16,-14,45,79,16,-127,-53,15,113,-16,89,-89,-84,32,-34,-58,47,127,112,-27,9,58,34,-94,108,118,-51,7,-48,-93,114,99,118,-60,32,-81,-32,-93,27,-19,-45,117,112,16,-1,44,-106,114,88,-119,-42,48,-59,74,106,-127,52,13,89,15,102,-126,-8,-71,66,68,27,-93,115,110,100,-60,32,-81,-32,-93,27,-19,-45,117,112,16,-1,44,-106,114,88,-119,-42,48,-59,74,106,-127,52,13,89,15,102,-126,-8,-71,66,68,27,-92,116,121,112,101,-93,112,97,121]
        var signedBytes = keyPair.sign(CustomEncoder.convertToUInt8Array(input: txBytes))
        var retValue = CustomEncoder.convertToInt8Array(input: signedBytes)
        let signature = try!Signature(retValue)
        var signedTransaction=SignedTransaction(sig: signature, tx: tx)
        return signedTransaction
    }
    
    public func signMultisigTransaction(from:MultisigAddress,  tx:Transaction) throws -> SignedTransaction {
           if !(tx.sender!.description == from.toString()) {
            throw Errors.illegalArgumentError("Transaction sender does not match multisig account");
           } else {
            var myPK:Ed25519PublicKey = Ed25519PublicKey(bytes: CustomEncoder.convertToInt8Array(input: self.keyPair.publicKey.bytes));
            var myI:Int = from.publicKeys.firstIndex(where: {ed25519PublicKey -> Bool in
                return ed25519PublicKey.bytes == myPK.bytes
            })!;
               if (myI == -1) {
                throw  Errors.illegalArgumentError("Multisig account does not contain this secret key");
               } else {
                var txSig:SignedTransaction = self.signTransaction(tx: tx);
                var mSig:MultisigSignature =  MultisigSignature(version: from.version, threshold: from.threshold);

                for i in 0..<from.publicKeys.count {
                       if (i == myI) {
                        mSig.subsigs!.append(MultisigSubsig(key: myPK, sig: txSig.sig!))
                       } else {
                        mSig.subsigs?.append(MultisigSubsig(key: from.publicKeys[i]));
                       }
                   }

                return  SignedTransaction(tx: tx, mSig: mSig, txId: tx.txID());
               }
           }
       }

    public func  mergeMultisigTransactions(txs:[SignedTransaction])throws ->SignedTransaction {
          if (txs.count < 2) {
            throw Errors.illegalArgumentError("cannot merge a single transaction");
          } else {
            var merged:SignedTransaction = txs[0];

            for i in 0..<txs.count {
                var tx:SignedTransaction = txs[i];
                if (tx.mSig!.version != merged.mSig!.version || tx.mSig!.threshold != merged.mSig!.threshold) {
                    throw  Errors.illegalArgumentError("transaction msig parameters do not match");
                  }

                for j in 0..<tx.mSig!.subsigs!.count {
                    var myMsig:MultisigSubsig = merged.mSig!.subsigs![j];
                    var theirMsig:MultisigSubsig = tx.mSig!.subsigs![j];
                    if !(theirMsig.key!.bytes==myMsig.key?.bytes) {
                        throw  Errors.illegalArgumentError("transaction msig public keys do not match");
                      }

                    if (myMsig.sig?.bytes==nil) {
                          myMsig.sig = theirMsig.sig;
                    } else if !(myMsig.sig!.bytes == theirMsig.sig!.bytes) && !(theirMsig.sig?.bytes==nil) {
                        throw  Errors.illegalArgumentError("transaction msig has mismatched signatures");
                      }

                    merged.mSig!.subsigs![j] = myMsig;
                  }
              }

              return merged;
          }
      }

    public func appendMultisigTransaction(from:MultisigAddress, signedTx:SignedTransaction) throws ->SignedTransaction {
        var sTx:SignedTransaction = try! self.signMultisigTransaction(from: from, tx: signedTx.tx);
        return try! mergeMultisigTransactions(txs:[sTx, signedTx]);
      }
    
}
