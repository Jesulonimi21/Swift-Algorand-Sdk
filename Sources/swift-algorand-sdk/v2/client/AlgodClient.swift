//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/9/21.
//

import Foundation


public class AlgodClient {
    var host:String
    var port:String
    var token:String
    var apiKey="x-api-key"
    public init(host:String,  port:String,  token:String) {
        self.host=host
        self.port=port
        self.token=token
    }
    
    func connectString()->URLComponents{
//        var components = URLComponents()
//            components.scheme = "https"
//            components.host = self.host
//        components.port=self.port
        var url=URL(string: host)!
        var components=URLComponents(url: url, resolvingAgainstBaseURL: false)
        components!.port=Int(self.port)
        return components!
    }
    
    

    public func rawTransaction()->RawTransaction {
        return  RawTransaction(client: self);
    }
//
    public func transactionParams() -> TransactionParams{
        return  TransactionParams(client:self);
    }
    public func getStatus()->GetStatus{
        return GetStatus(client: self)
    }
    public func pendingTransactionInformation(txId:String) ->PendingTransactionInformation{
        return PendingTransactionInformation(client: self, txId: txId)
    }
    
    public func accountInformation(address:String) ->AccountInformation{
        return AccountInformation(client: self, address: address)
    }
    
    public func getBlock(round:Int64) ->GetBlock{
        return GetBlock(client: self, round: round)
    }
    
    public func tealCompile()->TealCompile {
        return  TealCompile(client: self);
    }
    
    public func tealDryRun()->TealDryRun {
        return  TealDryRun(client: self);
    }
    
    public func getProof(round:Int64,txId:String) ->GetProof{
        return GetProof(client: self, round: round,txId: txId)
    }
    
    public func getSupply() -> GetSupply{
        return  GetSupply(client:self);
    }
    
    public func getVersion() -> GetVersion{
        return  GetVersion(client:self);
    }
    
    public func healthCheck() -> AlgodHealthCheck{
        return  AlgodHealthCheck(client:self);
    }
    
    public func swaggerJson() -> SwaggerJson{
        return SwaggerJson(client: self)
    }
    

    public func waitForBlock(round:Int64) ->WaitForBlock{
        return WaitForBlock(client: self, round: round)
    }
    
    public func getApplicationById(applicationId:Int64) -> GetApplicationById{
        return GetApplicationById(client: self, applicationId: applicationId)
    }
    
    public func getAssetById(assetId:Int64)->GetAssetById{
        return GetAssetById(client: self, assetId: assetId)
    }
    
    public func getGenesis() -> GetGenesis{
        return GetGenesis(client: self)
    }
    
    public func getPendingTransactions() -> GetPendingTransactions{
        return GetPendingTransactions(client: self)
    }
    
    public func getPendingTransactionsByAddress(address:Address) -> GetPendingTransactionsByAddress{
        return GetPendingTransactionsByAddress(client: self,address: address)
    }
    
    public func set(key:String){
        self.apiKey=key
    }

}
