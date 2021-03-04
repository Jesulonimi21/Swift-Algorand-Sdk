//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire
public class MakeHealthCheck  {
    var client:IndexerClient
    init(client:IndexerClient) {
        self.client=client
    }
//
    public func execute( callback: @escaping (_:Response<HealthCheck>)->Void) {
    
        let headers:HTTPHeaders=[client.apiKey:client.token]
        print(getRequestString())
        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
        var customResponse:Response<HealthCheck>=Response()
      request.responseDecodable(of: HealthCheck.self){ (response) in
        if(response.error != nil){
            customResponse.setIsSuccessful(value:false)
            var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
            customResponse.setErrorDescription(errorDescription:errorDescription!)
            callback(customResponse)
            return
        }
                        let data=response.value
                        var healthCheck:HealthCheck=data!
                        customResponse.setData(data:healthCheck)
                        customResponse.setIsSuccessful(value:true)
                        callback(customResponse)
             
        }
   
        
    }


    internal func getRequestString() ->String{
        var component=client.connectString()
        component.path = component.path + "/health"
      

        return component.url!.absoluteString;
    }
}
