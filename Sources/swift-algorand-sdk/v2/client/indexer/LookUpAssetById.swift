//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire
public class LookUpAssetById{
    var client:IndexerClient
    var rawTransaction:[Int8]?
    var id:Int64
    init(client:IndexerClient,id:Int64) {
        self.client=client
        self.id=id
    }

    public func execute( callback: @escaping (_:Response<AssetResponse>) ->Void){
//        print(getRequestString(parameter: self.id))
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(parameter: self.id),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })

        request.validate()
//        request.responseJSON(){response in
//            debugPrint(response.value)
//        }
//  request.responseDecodable(of: TransactionsResponse.self){  (response) in
        
        var customResponse:Response<AssetResponse>=Response()
      request.responseDecodable(of: AssetResponse.self){ (response) in
        if(response.error != nil){
            customResponse.setIsSuccessful(value:false)
            var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
            customResponse.setErrorDescription(errorDescription:errorDescription!)
            callback(customResponse)
            return
        }
                        let data=response.value
                        var assetResponse:AssetResponse=data!
                        customResponse.setData(data:assetResponse)
                        customResponse.setIsSuccessful(value:true)
                        callback(customResponse)

        }
    }

    internal func getRequestString(parameter:Int64)->String {
        var component=client.connectString()
        component.path = component.path+"/v2/assets/\(parameter)"
        return component.url!.absoluteString;
        
    }
}
