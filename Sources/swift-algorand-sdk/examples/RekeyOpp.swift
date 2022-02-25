//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 25/02/2022.
//

import Foundation
func rekeyFromAtoB(a: Account, b: Address, algodClient: AlgodClient, params: TransactionParametersResponse, functoCall: @escaping(Response<PostTransactionsResponse>) -> Void) {
    var tx = try! Transaction.paymentTransactionBuilder()
                .setSender(a.address)
                .receiver(a.address)
                .amount(0)
                .note("Swift Algo rekey transaction".bytes)
                .suggestedParams(params: params)
                .rekey(rekeyTo: b)
                .build()


    var signedTransaction = a.signTransaction(tx: tx)
    var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
    algodClient.rawTransaction(rawtxn: encodedTrans).execute(){
       response in
        functoCall(response)
    }
}

func makeTxnWithArekeyedToB(a: Address, b: Account, algodClient: AlgodClient, receiver: Address, params: TransactionParametersResponse, functoCall: @escaping(Response<PostTransactionsResponse>) -> Void){
    var tx = try! Transaction.paymentTransactionBuilder()
                 .setSender(a)
                 .receiver(receiver)
                 .amount(1000000)
                 .note("Swift Algo send transaction after rekey".bytes)
                 .suggestedParams(params: params)
                 .build();
    var signedTransaction = b.signTransaction(tx: tx)
    var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
    algodClient.rawTransaction(rawtxn: encodedTrans).execute(){
       response in
        functoCall(response)
    }
}
