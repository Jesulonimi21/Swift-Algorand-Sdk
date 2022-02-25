//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 18/02/2022.
//

import Foundation
// Create Account
// Send Algos
// Check Account Balance
// Get Account Address


var PURESTAKE_ALGOD_API_TESTNET_ADDRESS="https://testnet-algorand.api.purestake.io/ps2";
var PURESTAKE_API_KEY="YOUR-PURESTAKE-API-KEY";
var PURESTAKE_API_PORT="443";



var algodClient=AlgodClient(host: PURESTAKE_ALGOD_API_TESTNET_ADDRESS, port: PURESTAKE_API_PORT, token: PURESTAKE_API_KEY)

func initialiseAlgodClientWithCustomKey(key: String) -> AlgodClient{
    var algodClient=AlgodClient(host: PURESTAKE_ALGOD_API_TESTNET_ADDRESS, port: PURESTAKE_API_PORT,  apiKey: key, token: PURESTAKE_API_KEY);
    return algodClient
}

func createNewAccount()throws -> Account {
    var account = try Account()
    return account
}

func createAcountFromMnemonic(mnemonic: String)throws -> Account{
    var account = try Account(mnemonic);
    return account;
}

func createAccountFromSecretKey(secretKey: [Int8])throws -> Account{
    var account = try Account(secretKey)
    return account
}


func sendAlgos(from: Account, to: Address, amount: Int64, note: String) throws {
    var trans =  algodClient.transactionParams().execute(){ paramResponse in
        if(!(paramResponse.isSuccessful)){
        print(paramResponse.errorDescription);
        return;
    }
        var tx = try! Transaction.paymentTransactionBuilder().setSender(from.address)
            .amount(10)
            .receiver(to)
            .note(note.bytes)
            .suggestedParams(params: paramResponse.data!)
            .build()
        var signedTx = from.signTransaction(tx: tx);
        var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTx)
        algodClient.rawTransaction(rawtxn: encodedTrans).execute(){
           response in
            if(response.isSuccessful){
                print(response.data?.txId)
            }else{
                print(response.errorDescription)
                print("Failed")
            }

        }
    }

}

func printAccountBalance(address: Address) throws  {
    algodClient.accountInformation(address: address.description).execute(){response in
        if(response.isSuccessful){
            print(response.data!.amount)
        }else{
            print(response.errorDescription)
            print("Failed")
        }
    }
    
    func getAccountAddress(account: Account) -> Address{
        return account.address;
    }
}
