//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/27/21.
//

import Foundation
public class LimitOrder {
    private static var referenceProgram:String = "ASAKAAEFAgYEBwgJCiYBIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITMRYiEjEQIxIQMQEkDhAyBCMSQABVMgQlEjEIIQQNEDEJMgMSEDMBECEFEhAzAREhBhIQMwEUKBIQMwETMgMSEDMBEiEHHTUCNQExCCEIHTUENQM0ATQDDUAAJDQBNAMSNAI0BA8QQAAWADEJKBIxAiEJDRAxBzIDEhAxCCISEBA=";

    public init() {
    }
    
    
    public static  func  MakeLimitOrder(owner:Address,assetId:Int,ratn:Int,ratd:Int,expirationRound:Int,minTrade:Int,maxFee:Int) throws -> ContractTemplate {
      
        var values:[ContractTemplate.ParameterValue] =  [try ContractTemplate.IntParameterValue(offset: 5, value: maxFee),try ContractTemplate.IntParameterValue(offset: 7, value: minTrade),try ContractTemplate.IntParameterValue(offset: 9, value: assetId),try ContractTemplate.IntParameterValue(offset: 10, value: ratd),try ContractTemplate.IntParameterValue(offset: 11, value: ratn),try ContractTemplate.IntParameterValue(offset: 12, value: expirationRound),try ContractTemplate.AddressParameterValue(offset: 16, address: owner)]
        
        return try ContractTemplate.inject(program: CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: referenceProgram)), values: values);
    }

    
    public static func  MakeSwapAssetsTransaction(contract:ContractTemplate,assetAmount:Int64, microAlgoAmount:Int64, sender:Account,firstValid: Int64,lastValid:Int64,genesisHash:Digest, feePerByte:Int64) throws -> [Int8] {
        var data:AlgoLogic.ProgramData = try ContractTemplate.readAndVerifyContract(program: contract.program, numInts: 10, numByteArrays: 1);
            var owner =  try? Address(data.byteBlock[0]);
            var maxFee = data.intBlock[2];
            var minTrade = data.intBlock[4];
            var assetId = data.intBlock[6];
            var ratd = data.intBlock[7];
            var ratn = data.intBlock[8];
            if (assetAmount * ratd) != (microAlgoAmount * ratn) {
                throw Errors.illegalArgumentError("The exchange ratio of assets to microalgos must be exactly \(ratn) / \(ratd), received \(assetAmount) / \(microAlgoAmount)");
            } else if (microAlgoAmount < minTrade) {
                throw Errors.illegalArgumentError("At least \(minTrade) microalgos must be requested.");
            } else {
                var tx1 = try Transaction.paymentTransactionBuilder().setSender(contract.address).fee(feePerByte).firstValid(firstValid).lastValid(lastValid).genesisHash(genesisHash.bytes!).amount(microAlgoAmount).receiver(sender.address).build()
                
               

                var tx2 = try Transaction.assetTransferTransactionBuilder().setSender(sender.address).assetReceiver(assetReceiver: owner!).assetAmount(assetAmount: assetAmount).fee(feePerByte).firstValid(firstValid).lastValid(lastValid).genesisHash(genesisHash.bytes!).assetIndex(assetIndex: assetId).build()
                
                if tx1.fee! <= Int64(maxFee) && tx2.fee! <= Int64(maxFee) {
                    var gid = try TxGroup.computeGroupID(txns: [tx1,tx2])
                    tx1.assignGroupID(gid: gid)
                    tx2.assignGroupID(gid: gid)
                    var lsig = try LogicsigSignature(logicsig: contract.program);
                    var stx1 =  SignedTransaction(tx: tx1, lSig: lsig, txId: try tx1.txID());
                    var stx2 = try  sender.signTransaction(tx: tx2);

                    var encodedTrans:[Int8] = try CustomEncoder.encodeToMsgPack(stx1)+CustomEncoder.encodeToMsgPack(stx2)
//                    return baos.toByteArray();
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

    
    
