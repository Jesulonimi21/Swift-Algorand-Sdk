//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 18/02/2022.
//

import Foundation
// Create Asset
// Opt In
// Send Asset
// revokeAsset
// Freeze Asset
// Change Manager
func createAsset( algodClient:AlgodClient,creator:Account, assetTotal:Int64, assetDecimals:Int64, assetUnitName:String, assetName:String, url:String, manager:Address, reserve:Address,  freeze:Address, clawback:Address, defaultFrozen:Bool, functionToCall:@escaping (Response<PostTransactionsResponse>?)->Void){
    algodClient.transactionParams().execute(){paramResponse in
        if(!(paramResponse.isSuccessful)){
            print(paramResponse.errorDescription);
            return;
        }
    var tx = try! Transaction.assetCreateTransactionBuilder()
       .setSender(creator.getAddress())
                         .setAssetTotal(assetTotal: assetTotal)
                         .setAssetDecimals(assetDecimals:  assetDecimals)
                         .assetUnitName(assetUnitName: assetUnitName)
                         .assetName(assetName:  assetName)
                           .url(url: url)
                           .manager(manager: manager)
                           .reserve(reserve: reserve)
                           .freeze(freeze: freeze)
                         .defaultFrozen(defaultFrozen:  defaultFrozen)
               .clawback(clawback: clawback)
       .suggestedParams(params: paramResponse.data!).build()
   var signedTransaction=creator.signTransaction(tx: tx)
   var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
   var dataToSend=Data(CustomEncoder.convertToUInt8Array(input: encodedTrans))
   algodClient.rawTransaction(rawtxn: encodedTrans).execute(){
       response in
        functionToCall(response)
        }
    }
}


func optInToAsset(algodClient:AlgodClient, acceptingAccount:Account,
                  assetIndex:Int64, params: TransactionParametersResponse, functionToCall:@escaping (Response<PostTransactionsResponse>)->Void){
    var tx = try! Transaction.assetAcceptTransactionBuilder()
        .acceptingAccount(acceptingAccount: acceptingAccount.getAddress())
        .assetIndex(assetIndex: assetIndex)
        .suggestedParams(params: params)
        .build();
    
    var txMessagePack:[Int8]=CustomEncoder.encodeToMsgPack(tx)
    var signedTrans=acceptingAccount.signTransaction(tx: tx)
    var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
    algodClient.rawTransaction(rawtxn: encodedTx).execute(){
       response in
    functionToCall(response)
    }
}

func sendAsset(algodClient:AlgodClient, sender:Account, receiver:Address, amount:Int64,
               assetIndex:Int64, params: TransactionParametersResponse, functionToCall:@escaping (Response<PostTransactionsResponse>)->Void){
    var tx = try! Transaction.assetTransferTransactionBuilder()
                  .setSender(sender.getAddress())
                  .assetReceiver(assetReceiver:receiver)
                  .assetAmount(assetAmount:amount)
                  .assetIndex(assetIndex:assetIndex)
                  .suggestedParams(params:params)
                  .build();
    var signedTrans=sender.signTransaction(tx: tx)
    var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
    algodClient.rawTransaction(rawtxn: encodedTx).execute(){
       response in
    functionToCall(response)
    }
}

func revokeAsset(algodClient:AlgodClient, clawbackAccount:Account, clawBackFromAddress:Address,
                 clawBackToAddress:Address, assetAmount:Int64, assetIndex:Int64, params: TransactionParametersResponse,
                functionToCall:@escaping (Response<PostTransactionsResponse>)->Void){
    var tx = try! Transaction.assetClawbackTransactionBuilder()
                .setSender(clawbackAccount.getAddress())
                .assetClawbackFrom(assetClawbackFrom:clawBackFromAddress)
                .assetReceiver(assetReceiver: clawBackToAddress)
                .assetAmount(assetAmount: assetAmount)
                .assetIndex(assetIndex:assetIndex)
                .suggestedParams(params: params)
                .build()
    var signedTrans=clawbackAccount.signTransaction(tx: tx)
    var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
    algodClient.rawTransaction(rawtxn: encodedTx).execute(){
       response in
    functionToCall(response)
    }
}

func freezeAsset(algodClient:AlgodClient, freezeTarget:Address, manager:Account, assetIndex:Int64,
                 freezeState:Bool, params: TransactionParametersResponse,
                functionToCall:@escaping (Response<PostTransactionsResponse>)->Void){
    
    var tx = try! Transaction.assetFreezeTransactionBuilder()
                 .setSender(manager.getAddress())
                 .freezeTarget(freezeTarget:freezeTarget)
                 .freezeState(freezeState:freezeState)
                 .assetIndex(assetIndex: assetIndex)
                 .suggestedParams(params: params)
                 .build();
    var signedTrans=manager.signTransaction(tx: tx)
    var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
    algodClient.rawTransaction(rawtxn: encodedTx).execute(){
       response in
    functionToCall(response)
    }
}

func changeManager(algodClient:AlgodClient, previousManager:Account, assetIndex:Int64,
                    manager:Address, reserve:Address, freeze:Address, clawback:Address,
                    params: TransactionParametersResponse, functionToCall:@escaping (Response<PostTransactionsResponse>)->Void){
    var tx = try! Transaction.assetConfigureTransactionBuilder()
                 .reserve(reserve: previousManager.address)
                 .freeze(freeze: previousManager.address)
                 .clawback(clawback: previousManager.address)
                 .assetIndex(assetIndex: assetIndex)
                 .setSender(previousManager.getAddress())
                 .manager(manager: manager)
                 .suggestedParams(params: params)
                 .build();
    
    var signedTransaction=previousManager.signTransaction(tx: tx)
    var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
    algodClient.rawTransaction(rawtxn: encodedTx).execute(){
       response in
    functionToCall(response)
    }
}
