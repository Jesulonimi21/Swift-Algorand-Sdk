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
    
    public func searchForAssets( assetId:Int64? = nil, creator:String? = nil, limit:Int64? = nil, name:String? = nil, next:String? = nil, unit:String? = nil)->SearchForAssets{
        return SearchForAssets(client: self,  assetId: assetId , creator: creator, limit: limit, name: name, next: next, unit: unit)
    }
    
    public func lookUpAssetById(id:Int64)-> LookUpAssetById{
        return LookUpAssetById(client: self, id: id)
    }
    
    public func lookUpApplicationLogsById(id:Int64, limit:Int64? = nil, maxRound:Int64? = nil,
                                          minRound:Int64? = nil, next:String? = nil, senderAddress:Address? = nil, txid:String? = nil)-> LookUpApplicationLogsById{
        return LookUpApplicationLogsById(client: self, applicationId: id, limit: limit, maxRound: maxRound, minRound: minRound, next: next, senderAddress: senderAddress, txid: txid)
    }
    
    public func searchForTransactions(address:Address? = nil, applicationId:Int64? = nil, assetId:Int64? = nil,
                                      currencyGreaterThan:Int64? = nil,currencyLessThan:Int64? = nil, excludeCloseTo:Bool? = nil,
                                      limit: Int64? = nil, maxRound: Int64? = nil, minRound: Int64? = nil, next: String? = nil,
                                      notePrefix:Data? = nil, rekeyTo: Bool? = nil, round:Int64? = nil, txid:String? = nil)->SearchForTransactions{
        return SearchForTransactions(client: self, address: address, applicationId: applicationId, assetId: assetId, currencyLessThan: currencyGreaterThan, excludeCloseTo: excludeCloseTo, limit: limit, maxRound: maxRound, minRound: minRound, next: next,notePrefix: notePrefix, rekeyTo: rekeyTo,round: round, txid: txid )
    }

    public func searchForAccounts(applicationId:Int64? = nil, assetId:Int64? = nil, authAddr:Address? = nil, currencyGreaterThan:Int64? = nil, currencyLessThan:Int64? = nil, limit:Int64? = nil, next:String? = nil, round:Int64? = nil)->SearchForAccounts{
        return SearchForAccounts(client: self, applicationId: applicationId, assetId: assetId, authAddr: authAddr, currencyGreaterThan: currencyGreaterThan, currencyLessThan: currencyLessThan, limit: limit, next: next, round: round)
    }
    
    public func lookUpBlock(roundNumber:Int64)->LookupBlock{
        return LookupBlock(client: self, roundNumber: roundNumber)
    }
    
    public func lookUpAssetBalances(assetId:Int64, currencyGreaterThan:Int64? = nil, currencyLessThan:Int64? = nil, limit:Int64? = nil, round:Int64? = nil, next:String? = nil)->LookUpAssetBalances{
        return LookUpAssetBalances (client: self, assetId: assetId, currencyGreaterThan: currencyGreaterThan, currencyLessThan: currencyLessThan, limit: limit, round: round, next: next)
    }
    
    public func lookupAssetTransactions(assetId:Int64, address:Address? = nil, currencyGreaterThan:Int64? = nil, currencyLessThan:Int64? = nil,
                                        excludeCloseTo:Bool? = nil, limit:Int64? = nil, maxRound:Int64? = nil, minRound:Int64? = nil, next:String? = nil, notePrefix:Data? = nil, rekeyTo:Bool? = nil, round:Int64? = nil, txid:String? = nil)->LookUpAssetTransactions{
        return LookUpAssetTransactions (client: self, assetId: assetId, address: address, currencyGreaterThan: currencyGreaterThan, currencyLessThan: currencyLessThan, excludeCloseTo: excludeCloseTo, limit: limit, maxRound: maxRound, minRound: minRound,next: next,notePrefix: notePrefix, rekeyTo: rekeyTo, round: round, txid: txid)
    }
    
    public func set(key:String){
        self.apiKey=key
    }

}
