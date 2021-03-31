//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/28/21.
//

import Foundation
import CommonCrypto
import SwiftKeccak
public class HTLC {
    private static var referenceProgram:String = "ASAEBQEABiYDIP68oLsUSlpOp7Q4pGgayA5soQW8tgf8VlMlyVaV9qITAQYg5pqWHm8tX3rIZgeSZVK+mCNe0zNjyoiRi7nJOKkVtvkxASIOMRAjEhAxBzIDEhAxCCQSEDEJKBItASkSEDEJKhIxAiUNEBEQ";

    public init() {
    }


    public static  func  MakeHTLC(owner:Address, receiver:Address,hashFunction:String, hashImage:String,expiryRound: Int ,maxFee:Int) throws -> ContractTemplate {
        var hashInject:Int;
        if hashFunction=="sha256" {
            hashInject = 1;
        } else {
            if hashFunction != "keccak256" {
                throw Errors.runtimeError("invalid hash function supplied");
            }

            hashInject = 2;
        }

        var values:[ContractTemplate.ParameterValue] = [ContractTemplate.IntParameterValue(offset: 3, value: maxFee),  ContractTemplate.IntParameterValue(offset: 6, value: expiryRound),  ContractTemplate.AddressParameterValue(offset: 10, address: receiver),  ContractTemplate.BytesParameterValue(offset: 42, value: hashImage),ContractTemplate.AddressParameterValue(offset: 45, address: owner), ContractTemplate.IntParameterValue(offset: 102, value: hashInject)];
        return try ContractTemplate.inject(program: CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: referenceProgram)), values: values);
    }
    
    
    
    public static func  GetHTLCTransaction(contract:ContractTemplate,preImage:String,firstValid:Int64, lastValid:Int64, genesisHash:Digest, feePerByte:Int64) throws -> SignedTransaction {
        var data:AlgoLogic.ProgramData = try! ContractTemplate.readAndVerifyContract(program: contract.program, numInts: 4, numByteArrays: 3);
        
            var maxFee = data.intBlock[0];
        var receiver =  try Address(data.byteBlock[0]);
           var  hashImage = data.byteBlock[1];
            var  hashFunction = contract.program[contract.program.count - 15];
        var computedImage:[Int8];
            if (hashFunction == 1) {

                var decodedByte=CustomEncoder.decodeByteFromBase64(string: preImage)

                var computedImage=CustomEncoder.convertToSha256(data: Data(decodedByte))

                if(computedImage==hashImage){
                  
                }else{
                    throw Errors.runtimeError("Unable to verify SHA-256 preImage: sha256(preimage) != image");
                }

            } else {
                if (hashFunction != 2) {
                    throw Errors.runtimeError("Invalid contract detected, unable to find a valid hash function ID.");
                }
    
                var decodedByte=CustomEncoder.decodeByteFromBase64(string: preImage)
                var computedImageData=keccak256( Data(decodedByte))
                computedImage=CustomEncoder.convertToInt8Array(input: Array(computedImageData))
                if(computedImage==hashImage){
                 
                }else{
                    throw Errors.runtimeError("Unable to verify keccak256 preImage: keccak256(preimage) != image");
                }
            }
   
        var txn:Transaction = Transaction.paymentTransactionBuilder().setSender(contract.address).fee(0).firstValid(firstValid).lastValid(lastValid).genesisHash(genesisHash.bytes!).closeRemainderTo(receiver).build()
        
      txn =  try Account.setFeeByFeePerByte(tx: txn, suggestedFeePerByte: feePerByte);
        if (txn.fee! > maxFee) {
                throw Errors.runtimeError("Transaction fee is too high: \(txn.fee) > \(maxFee)" );
            } else {

                var args = [CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: preImage))]
                var lsig=LogicsigSignature(logicsig: contract.program, args: args)
                return  SignedTransaction(tx: txn, lsig: lsig);
            }
        }
    
    

}
