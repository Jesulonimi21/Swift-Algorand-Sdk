//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 19/01/2022.
//

import Foundation
import Alamofire

public class LookUpApplicationLogsById{
    var client:IndexerClient
    var rawTransaction:[Int8]?
    var applicationId:Int64
    
    
    init(client:IndexerClient,applicationId:Int64) {
        self.client=client
        self.applicationId = applicationId
    }
    
    public func execute( callback: @escaping (_:Response<ApplicationLogResponse>) ->Void){
        
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(parameter: self.applicationId),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
        request.validate()
        var customResponse:Response<ApplicationLogResponse>=Response()
  request.responseDecodable(of: ApplicationLogResponse.self){  (response) in

    if(response.error != nil){
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        if(response.data != nil){
            if let message = String(data: response.data!,encoding: .utf8){
                var errorDic = try! JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any]
                customResponse.errorMessage = errorDic!["message"] as! String
            }
        }
        return
    }
                    let data=response.value
                    var applicationLogResponse:ApplicationLogResponse=data!
                    customResponse.setData(data:applicationLogResponse)
                    customResponse.setIsSuccessful(value:true)
                    callback(customResponse)

    }
    }

    internal func getRequestString(parameter:Int64)->String {
        var component=client.connectString()
        component.path = component.path+"/v2/applications/\(parameter)/logs"
        return component.url!.absoluteString;
        
    }

}