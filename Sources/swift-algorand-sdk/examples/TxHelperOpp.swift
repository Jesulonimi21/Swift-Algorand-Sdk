//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 18/02/2022.
//

import Foundation

func waitForTransaction(txId:String, algodClient: AlgodClient, funcToCall: @escaping (PendingTransactionResponse?)->Void) {
    var confirmedRound: Int64?=0
    var assetIndex:Int64?=0
    algodClient.pendingTransactionInformation(txId:txId).execute(){
     pendingTransactionResponse in
        if(pendingTransactionResponse.isSuccessful){
            confirmedRound=pendingTransactionResponse.data!.confirmedRound
            if(confirmedRound != nil && confirmedRound! > 0){
                funcToCall(pendingTransactionResponse.data)
            }else{
                try!  waitForTransaction(txId: txId, algodClient: algodClient, funcToCall: funcToCall)
            }
        }else{
            print(pendingTransactionResponse.errorDescription!)
            funcToCall(nil)
            confirmedRound=12000;
        }
    }
}

func getTransactionParametersResponse(algodClient: AlgodClient, funcToCall: @escaping (TransactionParametersResponse?) -> Void){
    algodClient.transactionParams().execute(){ paramResponse in
        if(paramResponse.isSuccessful){
            funcToCall(paramResponse.data)
        }else{
            print("An error occurred");
            funcToCall(nil);
        }
    }
}

func groupTransactions(txns: [Transaction]) -> [Transaction]{
    var gid = try! TxGroup.computeGroupID(txns: txns)
    var signedTransactions:[SignedTransaction?]=Array(repeating: nil, count: txns.count)
    for i in 0 ..< txns.count{
        txns[i].assignGroupID(gid: gid)
    }
    return txns
}

public func makeAtomicTransfer(signedTransactions:[SignedTransaction?], algodClient:AlgodClient, functionToCall: @escaping (Response<PostTransactionsResponse>)->Void){
    var encodedTrans:[Int8]=Array()
    for i in 0..<signedTransactions.count{
        encodedTrans = encodedTrans + CustomEncoder.encodeToMsgPack(signedTransactions[i])
    }
    algodClient.rawTransaction().rawtxn(rawtaxn: encodedTrans).execute(){
       response in
        functionToCall(response)
    }
}

public  func getTransactionId(response: Response<PostTransactionsResponse>) -> String?{
    if(response.isSuccessful){
        return response.data?.txId
    }else{
        return response.errorDescription
    }
}

public func getAccountBalance(address: Address, algodClient: AlgodClient, funcToCall: @escaping(Int64?) -> Void){
    algodClient.accountInformation(address: address.description).execute(){
        accountInformationResponse in
        if(accountInformationResponse.isSuccessful){
            var balance = accountInformationResponse.data!.amount!
            funcToCall(balance)
        }else{
            funcToCall(nil)
        }
    }
}



