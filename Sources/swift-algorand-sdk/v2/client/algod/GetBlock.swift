//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/15/21.
//


import Foundation
import Alamofire
public class GetBlock{
    var client:AlgodClient
    var rawTransaction:[Int8]?
    var round:Int64
    init(client:AlgodClient,round:Int64) {
        self.client=client
        self.round=round
    }

    public func execute( callback: @escaping (_:Response<BlockResponse>) ->Void){
        print(getRequestString(parameter: self.round))
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(parameter: self.round),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })

        request.validate()
        var customResponse:Response<BlockResponse>=Response()
 
     
        request.responseDecodable(of: BlockResponse.self){  (response) in

    if(response.error != nil){
        
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        return
    }
    
                    
                    let data=response.value
                    var blockResponse:BlockResponse=data!
                    customResponse.setData(data:blockResponse)
                    customResponse.setIsSuccessful(value:true)
                    callback(customResponse)

    }
    }

    internal func getRequestString(parameter:Int64)->String {
        var component=client.connectString()
        component.path = component.path+"/v2/blocks/\(parameter)"
        return component.url!.absoluteString;
        
    }
}
