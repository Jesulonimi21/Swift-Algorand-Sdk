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
    init(client:IndexerClient) {
        self.client=client
        self.urlComponent=client.connectString()
        urlComponent.path = urlComponent.path + "/v2/assets"

    }
    public func execute( callback: @escaping (_:Response<AssetsResponse>)->Void) {
    
        let headers:HTTPHeaders=[client.apiKey:client.token]
        print(getRequestString())
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
            return
        }
                        let data=response.value
                        var assetsResponse:AssetsResponse=data!
                        customResponse.setData(data:assetsResponse)
                        customResponse.setIsSuccessful(value:true)
                        callback(customResponse)

        }
        
       
   
        
    }


    
    public func assetId(assetId:Int64)->SearchForAssets {
        self.queryItems["assetId"]="\(assetId)"
        return self;
    }

    public func creator(creator:String)->SearchForAssets {
        self.queryItems["creator"]="\(creator)"
        return self;
    }

    public func limit(limit:Int64)->SearchForAssets {
        self.queryItems["limit"]="\(limit)"
        return self;
    }

    public func name(name:String)->SearchForAssets {
        self.queryItems["name"]="\(name)"
        return self;
    }

    public func next(next:String)->SearchForAssets {
        self.queryItems["next"]="\(next)"
        return self;    }

    public func unit(unit:String) ->SearchForAssets{
        self.queryItems["unit"]="\(unit)"
        return self;
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
