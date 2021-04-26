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
    public var address:Address
   public var keyPair:KeyPair
   public var seed:Seed?
    var PROGDATA_SIGN_PREFIX:[Int8]=[80, 114, 111, 103, 68, 97, 116, 97, ]
   public static var MIN_TX_FEE_UALGOS:Int64 = 1000
    public  convenience init() throws{
      try  self.init(nil)
    }
    
    
   public init(_ bytes:[Int8]?) throws {
   
        if  let Ubytes = bytes{
            seed = try Seed(bytes:CustomEncoder.convertToUInt8Array(input: Ubytes))
        }else{
            seed = try Seed()
        }
       
        self.keyPair = KeyPair(seed: seed!)
      
        let ed25519PubKey = keyPair.publicKey.bytes.map{(UInt8bytes) -> Int8 in
            return unsafeBitCast(UInt8bytes, to: Int8.self)
        }
        self.address=try! Address(ed25519PubKey)
    }
    public   convenience init( _ mnemonic:String) throws{
      try  self.init(Mnemonic.toKey(mnemonic))
    }
    
    
    
  public  func getAddress() -> Address{
        return self.address
    }
    
  public  func toMnemonic() ->String{
        if let Useed=seed{
            var int8Bytes=Useed.bytes.map{(uint8Byts) in
                return unsafeBitCast(uint8Byts, to: Int8.self)}
            return try! Mnemonic.fromKey(int8Bytes)
        }
        return "An error occurred"
      
    }
    
  public  func signTransaction(tx:Transaction) -> SignedTransaction{
        var txBytes = tx.bytesToSign()
        var signedBytes = keyPair.sign(CustomEncoder.convertToUInt8Array(input: txBytes))
        var retValue = CustomEncoder.convertToInt8Array(input: signedBytes)
        let signature = try!Signature(retValue)
    var signedTransaction=SignedTransaction(tx: tx, sig: signature,txId: tx.txID())
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

    public static func  mergeMultisigTransactions(txs:[SignedTransaction])throws ->SignedTransaction {
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
                    } else if !(myMsig.sig!.bytes == theirMsig.sig?.bytes) && !(theirMsig.sig?.bytes==nil) {
                        throw  Errors.illegalArgumentError("transaction msig has mismatched signatures");
                      }

                    merged.mSig!.subsigs![j] = myMsig;
                  }
              }

              return merged;
          }
      }

    public func appendMultisigTransaction(from:MultisigAddress, signedTx:SignedTransaction) throws ->SignedTransaction {
        var sTx:SignedTransaction = try! self.signMultisigTransaction(from: from, tx: signedTx.tx!);
        return try! Account.mergeMultisigTransactions(txs:[sTx, signedTx]);
      }
    
    
    public func signLogicsig(lsig:LogicsigSignature) throws -> LogicsigSignature {
        var sig:Signature
        var bytesToSign:[Int8]=lsig.bytesToSign()
        var sigBytes=keyPair.sign(CustomEncoder.convertToUInt8Array(input: bytesToSign))
        sig = try! Signature(CustomEncoder.convertToInt8Array(input: sigBytes))
        lsig.sig = sig;
        return lsig;
        }
    
    
    public func rawSignBytes(bytes:[Int8])->Signature{
        var signedBytes = keyPair.sign(CustomEncoder.convertToUInt8Array(input: bytes))
        return try! Signature(CustomEncoder.convertToInt8Array(input: signedBytes) )
    }
    
    
    public static func estimatedEncodedSize(tx:Transaction) throws ->Int64 {
        var signedTrans = SignedTransaction(tx:tx,sig: try Account().rawSignBytes(bytes: tx.bytesToSign()), txId:tx.txID())
        var msgPack:[Int8] = CustomEncoder.encodeToMsgPack(signedTrans)
        return Int64(msgPack.count)
       }
    
    public static func setFeeByFeePerByte(tx:Transaction, suggestedFeePerByte:Int64) throws -> Transaction {
            if (suggestedFeePerByte < 0) {
                throw Errors.runtimeError("Cannot set fee to a negative number.");
            } else {
                tx.fee = suggestedFeePerByte;
                var size = try estimatedEncodedSize(tx: tx);
                var fee = suggestedFeePerByte*size;
                if fee < MIN_TX_FEE_UALGOS {
                    fee = MIN_TX_FEE_UALGOS;
                }

                tx.fee = fee
            }
        return tx
        }
    
    
    public func signMultisigTransactionBytes(from:MultisigAddress,tx:Transaction)->[Int8]{
        var signed  = try! self.signMultisigTransaction(from: from, tx: tx)
        return CustomEncoder.encodeToMsgPack(signed)
    }
    
    public func appendMultisigTransactionBytes(from:MultisigAddress,txBytes:[Int8]) ->[Int8]{
        var inTx = CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(CustomEncoder.convertToUInt8Array(input: txBytes)))
        var y:[Int8]=CustomEncoder.encodeToMsgPack(inTx)
        var appended = try! self.appendMultisigTransaction(from: from, signedTx: inTx)
        return CustomEncoder.encodeToMsgPack(appended)
    }
    
    
    public static func mergeMultisigTransactionBytes(txsBytes:[[Int8]])->[Int8]{
        var stxs = Array(repeating: SignedTransaction(),count: txsBytes.count)
        for i in 0..<txsBytes.count{
            stxs[i]=CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(CustomEncoder.convertToUInt8Array(input:txsBytes[i] )))
            
        }
        var merged = try! self.mergeMultisigTransactions(txs:stxs)
        return CustomEncoder.encodeToMsgPack(merged)
    }

    public static func signLogicsigTransaction(lsig:LogicsigSignature,tx:Transaction) -> SignedTransaction{
        return SignedTransaction(tx:tx,lSig:lsig,txId:tx.txID())
    }

    public func tealSign(data:[Int8],contractAddress:Address)->Signature{
        var rawAddress = contractAddress.bytes
        var rawData = PROGDATA_SIGN_PREFIX + rawAddress!+data
      return  self.rawSignBytes(bytes: rawData)
    }
    
    public func tealSignFromProgram( data:[Int8],  program:[Int8])->Signature {
        var lsig = try! LogicsigSignature(logicsig: program);
        return  try! self.tealSign(data: data, contractAddress: lsig.toAddress());
       }
    
    
    public func signLogicsig(lsig:LogicsigSignature,ma:MultisigAddress) throws -> LogicsigSignature{
        var myPk = Ed25519PublicKey(bytes: self.getAddress().getBytes())
        var index = ma.publicKeys.first{$0 == myPk}
        if let _ = index{
            var sig:Signature
            var bytesToSign = lsig.bytesToSign()
            sig = self.rawSignBytes(bytes: bytesToSign)
            
            var mSig = MultisigSignature(version: ma.version, threshold: ma.threshold)
            for i in 0..<ma.publicKeys.count{
                if ma.publicKeys[i] == index{
                    mSig.subsigs?.append(MultisigSubsig(key: myPk, sig: sig))
                }else{
                    mSig.subsigs?.append(MultisigSubsig(key: ma.publicKeys[i]))
                }
                
            }
            lsig.msig = mSig
            return lsig
        }else{
            throw Errors.illegalArgumentError("Multisig account does not contain this secret key")
        }
    }
    
    
    public func appendToLogicsig(lsig: LogicsigSignature) throws -> LogicsigSignature{
        var myPK = Ed25519PublicKey(bytes: self.getAddress().getBytes())
        var myIndex = -1
        for i in 0..<(lsig.msig?.subsigs?.count)!{
            var subsig = lsig.msig?.subsigs?[i]
            if (subsig?.key==myPK){
                myIndex = i
            }
        }
        
        if  myIndex != -1{
            var bytesToSign = lsig.bytesToSign()
            var sig = self.rawSignBytes(bytes: bytesToSign)
            lsig.msig?.subsigs?.insert(MultisigSubsig(key: myPK, sig: sig), at: myIndex)
            
            return lsig
        }else{
            throw Errors.illegalArgumentError("Multisig account does not contain this secret key")
        }
    }
  
//    public LogicsigSignature appendToLogicsig(LogicsigSignature lsig) throws IllegalArgumentException, IOException {
//            Ed25519PublicKey myPK = this.getEd25519PublicKey();
//            int myIndex = -1;
//            for (int i = 0; i < lsig.msig.subsigs.size(); i++ ) {
//                MultisigSubsig subsig = lsig.msig.subsigs.get(i);
//                if (subsig.key.equals(myPK)) {
//                    myIndex = i;
//                }
//            }
//            if (myIndex == -1) {
//                throw new IllegalArgumentException("Multisig account does not contain this secret key");
//            }
//
//            try {
//                // now, create the multisignature
//                byte[] bytesToSign = lsig.bytesToSign();
//                Signature sig = this.rawSignBytes(bytesToSign);
//                lsig.msig.subsigs.set(myIndex, new MultisigSubsig(myPK, sig));
//                return lsig;
//            } catch (NoSuchAlgorithmException ex) {
//                throw new IOException("could not sign transaction", ex);
//            }
//
//        }
}
