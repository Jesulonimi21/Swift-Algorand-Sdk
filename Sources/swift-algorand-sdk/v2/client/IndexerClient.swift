//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation

public class IndexerClient {
    var host:String
    var port:String
    var token:String
    var apiKey="X-Algo-API-Token"//X-API-Key
    public init(host:String,  port:String,  token:String) {
        self.host=host
        self.port=port
        self.token=token
    }
    
    func connectString()->URLComponents{
        var url=URL(string: host)!
        var components=URLComponents(url: url, resolvingAgainstBaseURL: false)
        components!.port=Int(self.port)
        return components!
    }
    
    public func makeHealthCheck()->MakeHealthCheck{
        return MakeHealthCheck(client: self)
    }
    
    public func lookUpAccountTransactions(address:String) -> LookUpAccountTransactions{
        return LookUpAccountTransactions(client: self, address: address)
    }
    
    public func lookUpAccountById(address:String) -> LookUpAccountById{
        return LookUpAccountById(client: self, address: address)
    }
    
    public func searchForApplications()->SearchForApplications{
        return SearchForApplications(client: self)
    }
    
    public func lookUpApplicationsById(id:Int64) ->LookUpApplicationsById{
      return  LookUpApplicationsById(client: self, id: id)
        
    }
    
    public func searchForAssets()->SearchForAssets{
       return SearchForAssets(client: self)
    }
    
    public func lookUpAssetById(id:Int64)-> LookUpAssetById{
        return LookUpAssetById(client: self, id: id)
    }
    
    public func searchForTransactions()->SearchForTransactions{
        return SearchForTransactions(client: self)
    }

    public func searchForAccounts()->SearchForAccounts{
        return SearchForAccounts(client: self)
    }
    
    public func lookUpBlocks(roundNumber:Int64)->LookupBlocks{
        return LookupBlocks(client: self, roundNumber: roundNumber)
    }
    
    public func lookUpAssetBalances(assetId:Int64)->LookUpAssetBalances{
        return LookUpAssetBalances (client: self, assetId: assetId)
    }
    
    public func lookupAssetTransactions(assetId:Int64)->LookUpAssetTransactions{
        return LookUpAssetTransactions (client: self, assetId: assetId)
    }
    
    public func set(key:String){
        self.apiKey=key
    }

}
