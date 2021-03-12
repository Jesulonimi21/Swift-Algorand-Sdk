//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation
import Alamofire
public class GetStatus{
    var client:AlgodClient
    var rawTransaction:[Int8]?
    init(client:AlgodClient) {
        self.client=client
    }

    public func execute( callback: @escaping (_:Response<NodeStatusResponse>) ->Void){
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
  print("Afetre request")
        request.validate()
        var customResponse:Response<NodeStatusResponse>=Response()
  request.responseDecodable(of: NodeStatusResponse.self){  (response) in

    if(response.error != nil){
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        return
    }
    
    customResponse.setIsSuccessful(value:true)
                    let data=response.value
                    var postTransactionResponse:NodeStatusResponse=data!
                    customResponse.setData(data:postTransactionResponse)
                    callback(customResponse)

    }
    }

    internal func getRequestString()->String {
        var component=client.connectString()
        component.path = component.path + "/v2/status/"
        return component.url!.absoluteString;
        
    }
}

