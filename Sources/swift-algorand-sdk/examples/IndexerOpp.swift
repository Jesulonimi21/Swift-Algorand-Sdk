//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 18/02/2022.
//

import Foundation


func initializeIndexer(host: String, port: String, token: String) -> IndexerClient {
    var  indexerClient=IndexerClient(host: host, port: port, token: token);
    return indexerClient
}


func initializeIndexerWithCustomKey(host: String, port: String, key: String, token: String) -> IndexerClient {
    var  indexerClient=IndexerClient(host: host, port: port, apiKey: key, token: token);
    return indexerClient
}


func lookUpHealthInfo(indexerClient: IndexerClient) {
    indexerClient.makeHealthCheck().execute(){
        response in
            if response.isSuccessful{
                print(response.data!.toJson()!)
            }else{
                print(response.errorDescription)
            }
}
}

func lookUPAccountInfo(indexerClient: IndexerClient, address: Address) {
    indexerClient.lookUpAccountById(address: address.description).execute(){
        response in
            if response.isSuccessful{
                    print("success")
                print(response.data!.toJson()!)
            }else{
                print(response.errorDescription)
            }
}
}

func lookUpAccountTransactions(indexerClient: IndexerClient, address: Address) {
    indexerClient.lookUpAccountTransactions(address: address.description).execute(){
        response in
            if response.isSuccessful{
               
                print("success")
                print(response.data!.toJson()!)
            }else{
                print(response.errorDescription)
            }
        }
}

func searchForApplications(indexerClient: IndexerClient) {
    indexerClient.searchForApplications().execute(){
        response in
        if response.isSuccessful{
                print(response.data!.toJson()!)
            }else{
                print(response.errorDescription)
            }
        }
}


func lookupApplicationById(indexerClient: IndexerClient, appId: Int64) {
    indexerClient.lookUpApplicationsById(id: appId).execute(){
        response in
         if response.isSuccessful{
               print(response.data!.toJson()!)
           }else{
               print(response.errorDescription)
           }
       }
}

func searchForAssets(indexerClient: IndexerClient, assetId: Int64) {
    indexerClient.searchForAssets(assetId: assetId).execute(){
        response in
            if response.isSuccessful{
                print(response.data!.toJson()!)
            }else{
                print(response.errorDescription)
            }
        }
}

    func lookupAssetsById(indexerClient: IndexerClient, assetId: Int64) {
    indexerClient.lookUpAssetById(id: assetId).execute(){
        response in
            if response.isSuccessful{
                print(response.data!.toJson()!)
            }else{
                print(response.errorDescription)
            }
        }
        
    }
