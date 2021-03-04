//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//


import Foundation
import Alamofire
public class PendingTransactionInformation{
    var client:AlgodClient
    var rawTransaction:[Int8]?
    var txId:String
    init(client:AlgodClient,txId:String) {
        self.client=client
        self.txId=txId
    }

    internal func execute( callback: @escaping (_:Response<PendingTransactionResponse>) ->Void){
        print(getRequestString(parameter: self.txId))
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(parameter: self.txId),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
  print("Afetre request")
        request.validate()
        var customResponse:Response<PendingTransactionResponse>=Response()
  request.responseDecodable(of: PendingTransactionResponse.self){  (response) in

    if(response.error != nil){
        
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        return
    }
    
                    
                    let data=response.value
                    var postTransactionResponse:PendingTransactionResponse=data!
                    customResponse.setData(data:postTransactionResponse)
                    customResponse.setIsSuccessful(value:true)
                    callback(customResponse)

    }
    }

    internal func getRequestString(parameter:String)->String {
        var component=client.connectString()
        component.path = component.path+"/v2/transactions/pending/\(parameter)"
        return component.url!.absoluteString;
        
    }
}

