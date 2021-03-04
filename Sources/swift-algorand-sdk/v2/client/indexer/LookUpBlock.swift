//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
import Alamofire
public class LookupBlocks{
    var client:IndexerClient
    var rawTransaction:[Int8]?
    var roundNumber:Int64
    init(client:IndexerClient,roundNumber:Int64) {
        self.client=client
        self.roundNumber=roundNumber
    }

    internal func execute( callback: @escaping (_:Response<Block>) ->Void){
        print(getRequestString(parameter: self.roundNumber))
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(parameter: self.roundNumber),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
  print("Afetre request")
        request.validate()
        var customResponse:Response<Block>=Response()
//        request.responseJSON(){response in
//            debugPrint(response.value)
//        }
  request.responseDecodable(of: Block.self){  (response) in

    if(response.error != nil){
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        return
    }
                    let data=response.value
                    var block:    Block=data!
                    customResponse.setData(data:block)
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
