//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
import Alamofire
public class GetAssetById{
    var client:AlgodClient

    var assetId:Int64
    init(client:AlgodClient,assetId:Int64) {
        self.client=client
        self.assetId=assetId
    }

    public func execute( callback: @escaping (_:Response<  AssetData>) ->Void){
//        print(getRequestString(parameter: self.assetId))
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(parameter: self.assetId),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
        request.validate()
        var customResponse:Response<AssetData>=Response()
 
     
        request.responseDecodable(of:  AssetData.self){  (response) in

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
                    var assetResponse:AssetData=data!
                    customResponse.setData(data:assetResponse)
                    customResponse.setIsSuccessful(value:true)
                    callback(customResponse)

    }
    }

    internal func getRequestString(parameter:Int64)->String {
        var component=client.connectString()
        component.path = component.path+"/v2/assets/\(assetId)"
        return component.url!.absoluteString;
        
    }
}
