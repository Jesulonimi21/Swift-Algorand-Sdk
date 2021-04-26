//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/22/21.
//

import Foundation

public class Split {
    private static var referenceProgram:String = "ASAIAQUCAAYHCAkmAyDYHIR7TIW5eM/WAZcXdEDqv7BD+baMN6i2/A5JatGbNCDKsaoZHPQ3Zg8zZB/BZ1oDgt77LGo5np3rbto3/gloTyB40AS2H3I72YCbDk4hKpm7J7NnFy2Xrt39TJG0ORFg+zEQIhIxASMMEDIEJBJAABkxCSgSMQcyAxIQMQglEhAxAiEEDRAiQAAuMwAAMwEAEjEJMgMSEDMABykSEDMBByoSEDMACCEFCzMBCCEGCxIQMwAIIQcPEBA=";

    public init() {
    }

    
    public static  func MakeSplit(owner: Address, receiver1:Address, receiver2:Address,rat1:Int,rat2:Int,expiryRound:Int,minPay:Int, maxFee:Int) throws -> ContractTemplate {
        var values:[ContractTemplate.ParameterValue] = [ ContractTemplate.IntParameterValue(offset: 4, value: maxFee),  ContractTemplate.IntParameterValue(offset: 7, value: expiryRound),  ContractTemplate.IntParameterValue(offset: 8, value: rat2),  ContractTemplate.IntParameterValue(offset: 9, value: rat1),  ContractTemplate.IntParameterValue(offset: 10, value: minPay),  ContractTemplate.AddressParameterValue(offset: 14, address: owner),  ContractTemplate.AddressParameterValue(offset: 47, address: receiver1),  ContractTemplate.AddressParameterValue(offset: 80, address: receiver2)]
        
        return try ContractTemplate.inject(program: CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: referenceProgram)), values: values);
        }
    
    
    
    
     
    public static func GetSplitTransactions(contract:ContractTemplate,  amount:Int64,firstValid:Int64, lastValid:Int64,feePerByte:Int64, genesisHash:Digest) throws ->[Int8] {
        var data:AlgoLogic.ProgramData = try! ContractTemplate.readAndVerifyContract(program: contract.program, numInts: 8, numByteArrays: 3);
            var maxFee = data.intBlock[1]
            var rat1 = data.intBlock[6]
            var rat2 = data.intBlock[5];
            var minTrade = data.intBlock[7];
        var fraction:Double = Double(rat1) / ( Double(rat1) + Double(rat2))
        var receiverOneAmount:Int64 = Int64(fraction * Double(amount))
        var receiverTwoAmount:Int64 = Int64((1.0 - fraction) * Double(amount))
            if (Int64(amount) - receiverOneAmount - receiverTwoAmount != 0) {
                throw Errors.runtimeError("Unable to exactly split \(amount) using the contract ratio of \(rat1) /  \(rat2)"  );
            } else if (receiverOneAmount < minTrade) {
                throw Errors.runtimeError("Receiver one must receive at least \(minTrade)");
            } else {
                var rcv1 = receiverOneAmount * Int64(rat2)
                var rcv2 = receiverTwoAmount * Int64(rat1)
                if ( rcv1 != rcv2) {
                    throw Errors.runtimeError("The token split must be exactly \(rat1)  / \(rat2), received  \(receiverOneAmount) / \(receiverTwoAmount)");
                } else {
                    var receiver1 =  try! Address(data.byteBlock[1]);
                    var receiver2 = try!  Address(data.byteBlock[2]);
             
                    
                    var tx1 = try! Transaction.paymentTransactionBuilder().setSender(contract.address)
                     .amount(receiverOneAmount)
                     .receiver(receiver1)
                        .genesisHash(genesisHash.bytes!)
                        .lastValid(Int64(lastValid))
                        .firstValid(Int64(firstValid))
                        .fee(Int64(feePerByte))
                         .build()

                    var tx2 = try! Transaction.paymentTransactionBuilder().setSender(contract.address)
                     .amount(receiverTwoAmount)
                     .receiver(receiver2)
                        .genesisHash(genesisHash.bytes!)
                        .lastValid(Int64(lastValid))
                        .firstValid(Int64(firstValid))
                        .fee(Int64(feePerByte))
                         .build()

                    
                    
                    if (tx1.fee! <= Int64(maxFee) && tx2.fee! <= Int64(maxFee)) {
                        var lsig = try! LogicsigSignature(logicsig: contract.program);
                        var gid = try! TxGroup.computeGroupID(txns: [tx1,tx2])
                        tx1.assignGroupID(gid: gid)
                        tx2.assignGroupID(gid: gid)
                    
                        var stx1 =  SignedTransaction(tx: tx1, lSig: lsig, txId: tx1.txID());
                        var stx2 =  SignedTransaction(tx: tx2, lSig: lsig, txId: tx2.txID());
                    var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(stx1)+CustomEncoder.encodeToMsgPack(stx2)
                    return encodedTrans
                    } else {
                        var fee:Int64
                        if(tx1.fee! > tx2.fee!){
                            fee=tx1.fee!
                        }else{
                            fee=tx2.fee!
                        }
                       
                        throw Errors.runtimeError("Transaction fee is greater than maxFee: \(fee) > \(maxFee)");
                    }
                }
            }
        }
    

}
