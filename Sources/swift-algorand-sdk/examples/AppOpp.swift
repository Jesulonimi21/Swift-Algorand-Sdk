//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 18/02/2022.
//

import Foundation
//Compile Teal
//Create App
//Read Data from App
//Update App
//close App


func compileTeal(algodClient: AlgodClient, source: [Int8], callback: @escaping(CompileResponse?) -> Void ){
    algodClient.tealCompile().source(source: source).execute(){compileResponse in
        callback(compileResponse.data);
    }
}

func createApp(localInts: Int64, localBytes: Int64, globalInts: Int64, globalBytes: Int64, compiledAapprovalProgram: TEALProgram, compiledClearProgram: TEALProgram, params: TransactionParametersResponse, account: Account, algodClient: AlgodClient, callback: @escaping (Response<RawTransaction.ResponseType>) -> Void) throws {
    var sender = account.getAddress();
    var tx = try Transaction.applicationCreateTransactionBuilder()
        .setSender(sender)
        .approvalProgram(approvalProgram: compiledAapprovalProgram)
        .clearStateProgram(clearStateProgram: compiledClearProgram)
        .globalStateSchema(globalStateSchema: StateSchema(numUint: globalInts, numByteSlice: globalBytes))
        .localStateSchema(localStateSchema:StateSchema(numUint: localInts, numByteSlice: localBytes))
        .suggestedParams(params: params)
        .build()
    var signedTransaction=account.signTransaction(tx: tx)

    var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
    algodClient.rawTransaction(rawtxn: encodedTrans).execute(){
       response in
       callback(response)
    }

}

func readLocalState(account:Account, applicationId:Int64, algodClient: AlgodClient){
    var sender = account.getAddress();
    algodClient.accountInformation(address: sender.description).execute(){accountInformationResponse in
        
    if(!(accountInformationResponse.isSuccessful)){
        print(accountInformationResponse.errorDescription);
        return;
    }
        if let appsLocalState = accountInformationResponse.data?.appsLocalState{
            for i in 0..<appsLocalState.count{
                if appsLocalState[i].id ?? -1 == applicationId{
                    for j in 0..<(appsLocalState[i].keyValue?.count ?? 0){
                        print(appsLocalState[i].keyValue![j].key)
                        print(appsLocalState[i].keyValue![j].value.bytes)
                        print(appsLocalState[i].keyValue![j].value.type)
                        print(appsLocalState[i].keyValue![j].value.uint)
                        var dDat = CustomEncoder.decodeFromBase64(CustomEncoder.convertBase64ToByteArray(data1: appsLocalState[i].keyValue![j].key))
                        var  keyString = String(data: dDat, encoding: .utf8)!
                        print("\(keyString): \(appsLocalState[i].keyValue![j].value.bytes)  \(appsLocalState[i].keyValue![j].value.uint) \n")
                    }
                }
                print( appsLocalState[i].id)
            }
        }
        
    }
}

func printGlobalState(account:Account, applicationId:Int64, algodClient: AlgodClient, creatorAddress: Address){
    algodClient.accountInformation(address: creatorAddress.description).execute(){accountInformationResponse in
            if(!accountInformationResponse.isSuccessful){
                print(accountInformationResponse.errorDescription!)
                return
            }
                if let createdApps = accountInformationResponse.data?.createdApps{
                    for i in 0..<createdApps.count{
                        if createdApps[i].id! == applicationId{
                            for j in 0..<(createdApps[i].params?.globalState?.count ?? 0) ?? 0..<0{
                                 print(createdApps[i].params?.globalState![j].key)
                                print(createdApps[i].params?.globalState![j].value.bytes)
                                print(createdApps[i].params?.globalState![j].value.type)
                                print(createdApps[i].params?.globalState![j].value.uint)
                                var dDat = CustomEncoder.decodeFromBase64(CustomEncoder.convertBase64ToByteArray(data1: (createdApps[i].params?.globalState![j].key)!))
                                var  keyString = String(data: dDat, encoding: .utf8)!
                                print("\(keyString): \(createdApps[i].params?.globalState![j].value.bytes)  \(createdApps[i].params?.globalState![j].value.uint) \n")
                            }
                        }
                    }
                }
            }
        }
    

func callApp(account: Account, params: TransactionParametersResponse, data: Data, applicationId: Int64, callback: @escaping (Response<RawTransaction.ResponseType>) -> Void) throws{
    var sender = account.getAddress();
    var ingt8Arr = CustomEncoder.convertToInt8Array(input: Array(data));
    var tx = try Transaction.applicationCallTransactionBuilder()
        .setSender(sender)
        .applicationId(applicationId: applicationId)
        .suggestedParams(params: params)
        .args(args: [ingt8Arr])
        .build()
   var signedTransaction=account.signTransaction(tx: tx)
   var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
    algodClient.rawTransaction(rawtxn: encodedTrans).execute(){
       response in
       callback(response)
    }
}

func updateApp(localInts: Int64, localBytes: Int64, globalInts: Int64, globalBytes: Int64, compiledAapprovalProgram: TEALProgram, compiledClearProgram: TEALProgram, params: TransactionParametersResponse, account: Account, algodClient: AlgodClient, applicationId:Int64, callback: @escaping (Response<RawTransaction.ResponseType>) -> Void) throws {
    var sender = account.getAddress()
    var tx = try Transaction.applicationUpdateTransactionBuilder()
        .setSender(sender)
        .approvalProgram(approvalProgram: compiledAapprovalProgram)
        .clearStateProgram(clearStateProgram: compiledClearProgram)
        .applicationId(applicationId:applicationId)
        .suggestedParams(params: params)
        .build();
    var signedTransaction=account.signTransaction(tx: tx)
    var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
    algodClient.rawTransaction(rawtxn: encodedTrans).execute(){
       response in
       callback(response)
    }
}

func closeApp(params: TransactionParametersResponse, applicationId:Int64, algodClient: AlgodClient,  account: Account, callback: @escaping (Response<RawTransaction.ResponseType>) -> Void) throws {
  
    var sender = account.getAddress()
    var tx = try Transaction.applicationCloseTransactionBuilder()
        .setSender(sender)
        .applicationId(applicationId:   applicationId)
        .suggestedParams(params: params)
        .build()
    
    var signedTransaction=account.signTransaction(tx: tx)
    var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
    algodClient.rawTransaction(rawtxn: encodedTrans).execute(){
       response in
       callback(response)
    }
}





