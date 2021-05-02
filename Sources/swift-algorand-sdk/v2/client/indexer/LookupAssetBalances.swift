//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//
import Foundation
import Alamofire
public class LookUpAssetBalances  {
    var client:IndexerClient
    var urlComponent:URLComponents;
    var queryItems:[String:String]=[:]
    var assetId:Int64
    init(client:IndexerClient,assetId:Int64) {
        self.assetId=assetId
        self.client=client
        self.urlComponent=client.connectString()
        urlComponent.path = urlComponent.path + "/v2/assets/\(assetId)/balances"

    }
    public func execute( callback: @escaping (_:Response<AssetBalancesResponse>)->Void) {
    
        let headers:HTTPHeaders=[client.apiKey:client.token]
//        print(getRequestString())
        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.responseJSON(){response in
//            debugPrint(response.value)
//        }
        var customResponse:Response<AssetBalancesResponse>=Response()
      request.responseDecodable(of: AssetBalancesResponse.self){ (response) in
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
                        var assetBalancesResponse:AssetBalancesResponse=data!
                        customResponse.setData(data:assetBalancesResponse)
                        customResponse.setIsSuccessful(value:true)
                        callback(customResponse)

        }
        
       
   
        
    }

    
    
   

    public func currencyGreaterThan(currencyGreaterThan:Int64)->LookUpAssetBalances {
        self.queryItems["currency-greater-than"]="\(currencyGreaterThan)"
        return self;
    }
    
    public func currencyLessThan(currencyLessThan:Int64) ->LookUpAssetBalances{
        self.queryItems["currency-less-than"]="\(currencyLessThan)"
        return self;
    }


    public func limit(limit:Int64)->LookUpAssetBalances {
        self.queryItems["limit"]="\(limit)"
        return self;
    }

    public func name(round:Int64)->LookUpAssetBalances {
        self.queryItems["round"]="\(round)"
        return self;
    }

    public func next(next:String)->LookUpAssetBalances {
        self.queryItems["next"]="\(next)"
        return self;    }

    
    internal func getUrlComponent() ->URLComponents{
        var component=client.connectString()
        component.path = component.path + "/v2/assets/\(self.assetId)/balances"

//        return component.url!.absoluteString;
        return component;
    }
    
    func getRequestString()->String{
        self.urlComponent.setQueryItems(with: queryItems)
        return urlComponent.url!.absoluteString;
    }
}
