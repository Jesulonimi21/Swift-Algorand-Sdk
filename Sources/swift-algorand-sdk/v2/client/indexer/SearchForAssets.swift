//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//


extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}


import Foundation
import Alamofire
public class SearchForAssets  {
    var client:IndexerClient
    var urlComponent:URLComponents;
    var queryItems:[String:String]=[:]
    
    init(client:IndexerClient, assetId:Int64? = nil, creator:String? = nil, limit:Int64? = nil, name:String? = nil, next:String? = nil, unit:String? = nil ) {
        self.client=client
        self.urlComponent=client.connectString()
        urlComponent.path = urlComponent.path + "/v2/assets"
        if let assetid = assetId{
            self.queryItems["asset-id"]="\(assetid)"
        }
        if let assetCreator = creator{
            self.queryItems["creator"]="\(assetCreator)"
        }
        if let assetLimit = limit{
            self.queryItems["limit"]="\(assetLimit)"
        }
        
        if let assetName = name{
            self.queryItems["name"]="\(assetName)"
        }
        
        if let assetNext = next{
            self.queryItems["next"]="\(assetNext)"
        }
        
        if let assetUnit = unit{
            self.queryItems["unit"]="\(assetUnit)"
        }
    }
    public func execute( callback: @escaping (_:Response<AssetsResponse>)->Void) {
    
        let headers:HTTPHeaders=[client.apiKey:client.token]
//        print(getRequestString())
        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.responseJSON(){response in
//            debugPrint(response.value)
//        }
        var customResponse:Response<AssetsResponse>=Response()
      request.responseDecodable(of: AssetsResponse.self){ (response) in
        if(response.error != nil){
            customResponse.setIsSuccessful(value:false)
            var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
            customResponse.setErrorDescription(errorDescription:errorDescription!)
            callback(customResponse)
            print(response.error!.errorDescription)
            if(response.data != nil){
                if let message = String(data: response.data!,encoding: .utf8){
                    var errorDic = try! JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any]
                    customResponse.errorMessage = errorDic!["message"] as! String
                 
                }

            }
            return
        }
                        let data=response.value
                        var assetsResponse:AssetsResponse=data!
                        customResponse.setData(data:assetsResponse)
                        customResponse.setIsSuccessful(value:true)
                        callback(customResponse)

        }
    }
    
    internal func getUrlComponent() ->URLComponents{
        var component=client.connectString()
        component.path = component.path + "/v2/assets"
//        return component.url!.absoluteString;
        return component;
    }
    
     func getRequestString()->String{
        self.urlComponent.setQueryItems(with: queryItems)
        return urlComponent.url!.absoluteString;
    }
}
