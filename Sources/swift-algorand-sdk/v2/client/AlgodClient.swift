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
    var apiKey="X-Algo-API-Token"
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
    
    public func set(key:String){
        self.apiKey=key
    }

}
