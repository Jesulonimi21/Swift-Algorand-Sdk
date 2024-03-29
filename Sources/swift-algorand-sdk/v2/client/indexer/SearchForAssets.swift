//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

// extension URLComponents {
//
//    mutating func setQueryItems(with parameters: [String: String]) {
//        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//    }
// }

import Foundation


public class SearchForAssets: Request {
    public typealias ResponseType = AssetsResponse
    public let client: HTTPClient
    public var parameters: RequestParameters
    
    private var queryItems: [String: String] = [:] {
        didSet { parameters.queryParameters = queryItems }
    }
    
    init(client: IndexerClient,
         assetId: Int64? = nil,
         creator: String? = nil,
         limit: Int64? = nil,
         name: String? = nil,
         next: String? = nil,
         unit: String? = nil ) {
        self.client = client
        parameters = .init(path: "/v2/assets")
        let query: [String: CustomStringConvertible?]
        query = [
            "asset-id": assetId,
            "creator": creator,
            "limit": limit,
            "name": name,
            "next": next,
            "unit": unit
        ]
        
        self.queryItems = query.compactMapValues { $0?.description }
        
    }
    @available(*, deprecated, message: "Use `init` instead")
    public func assetId(assetId: Int64) -> SearchForAssets {
        self.queryItems["assetId"]="\(assetId)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func creator(creator: String) -> SearchForAssets {
        self.queryItems["creator"]="\(creator)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func limit(limit: Int64) -> SearchForAssets {
        self.queryItems["limit"]="\(limit)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func name(name: String) -> SearchForAssets {
        self.queryItems["name"]="\(name)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func next(next: String) -> SearchForAssets {
        self.queryItems["next"]="\(next)"
        return self
    }
    
    @available(*, deprecated, message: "Use `init` instead")
    public func unit(unit: String) -> SearchForAssets {
        self.queryItems["unit"]="\(unit)"
        return self
    }
}

//
// public class SearchForAssets  {
//    var client:IndexerClient
//    var urlComponent:URLComponents;
//    var queryItems:[String:String]=[:]
//
//    init(client:IndexerClient, assetId:Int64? = nil, creator:String? = nil, limit:Int64? = nil, name:String? = nil, next:String? = nil, unit:String? = nil ) {
//        self.client=client
//        self.urlComponent=client.connectString()
//        urlComponent.path = urlComponent.path + "/v2/assets"
//        if let assetid = assetId{
//            self.queryItems["asset-id"]="\(assetid)"
//        }
//        if let assetCreator = creator{
//            self.queryItems["creator"]="\(assetCreator)"
//        }
//        if let assetLimit = limit{
//            self.queryItems["limit"]="\(assetLimit)"
//        }
//
//        if let assetName = name{
//            self.queryItems["name"]="\(assetName)"
//        }
//
//        if let assetNext = next{
//            self.queryItems["next"]="\(assetNext)"
//        }
//
//        if let assetUnit = unit{
//            self.queryItems["unit"]="\(assetUnit)"
//        }
//    }
//    public func execute( callback: @escaping (_:Response<AssetsResponse>)->Void) {
//
//        let headers:HTTPHeaders=[client.apiKey:client.token]
////        print(getRequestString())
//        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
////        request.responseJSON(){response in
////            debugPrint(response.value)
////        }
//        var customResponse:Response<AssetsResponse>=Response()
//      request.responseDecodable(of: AssetsResponse.self){ (response) in
//        if(response.error != nil){
//            customResponse.setIsSuccessful(value:false)
//            var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
//            customResponse.setErrorDescription(errorDescription:errorDescription!)
//            callback(customResponse)
//            print(response.error!.errorDescription)
//            if(response.data != nil){
//                if let message = String(data: response.data!,encoding: .utf8){
//                    var errorDic = try! JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any]
//                    customResponse.errorMessage = errorDic!["message"] as! String
//
//                }
//
//            }
//            return
//        }
//                        let data=response.value
//                        var assetsResponse:AssetsResponse=data!
//                        customResponse.setData(data:assetsResponse)
//                        customResponse.setIsSuccessful(value:true)
//                        callback(customResponse)
//
//        }
//    }
//
//    public func assetId(assetId:Int64)->SearchForAssets {
//        self.queryItems["assetId"]="\(assetId)"
//        return self;
//    }
//
//    public func creator(creator:String)->SearchForAssets {
//        self.queryItems["creator"]="\(creator)"
//        return self;
//    }
//
//    public func limit(limit:Int64)->SearchForAssets {
//        self.queryItems["limit"]="\(limit)"
//        return self;
//    }
//
//    public func name(name:String)->SearchForAssets {
//        self.queryItems["name"]="\(name)"
//        return self;
//    }
//
//    public func next(next:String)->SearchForAssets {
//        self.queryItems["next"]="\(next)"
//        return self;    }
//
//    public func unit(unit:String) ->SearchForAssets{
//        self.queryItems["unit"]="\(unit)"
//        return self;
//    }
//
//    internal func getUrlComponent() ->URLComponents{
//        var component=client.connectString()
//        component.path = component.path + "/v2/assets"
////        return component.url!.absoluteString;
//        return component;
//    }
//
//     func getRequestString()->String{
//        self.urlComponent.setQueryItems(with: queryItems)
//        return urlComponent.url!.absoluteString;
//    }
// }
