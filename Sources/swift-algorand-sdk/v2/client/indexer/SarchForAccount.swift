//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire
public class SearchForAccounts  {
    var client:IndexerClient
    var urlComponent:URLComponents;
    var queryItems:[String:String]=[:]
    init(client:IndexerClient) {
        self.client=client
        self.urlComponent=client.connectString()
        urlComponent.path = urlComponent.path + "/v2/accounts"

    }
    public func execute( callback: @escaping (_:Response<AccountsResponse>)->Void) {

        let headers:HTTPHeaders=[client.apiKey:client.token]
//        print(getRequestString())
        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.responseJSON(){response in
//            debugPrint(response.value)
//        }
        var customResponse:Response<AccountsResponse>=Response()
      request.responseDecodable(of: AccountsResponse.self){ (response) in
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
                        var accountsResponse:AccountsResponse=data!
                        customResponse.setData(data:accountsResponse)
                        customResponse.setIsSuccessful(value:true)
                        callback(customResponse)

        }




    }


    public func applicationId(applicationId:Int64)->SearchForAccounts {
           self.queryItems["application-id"] = "\(applicationId)"
           return self;
       }

    public func assetId(assetId:Int64)->SearchForAccounts {
           self.queryItems["asset-id"]="\(assetId)"
           return self
       }

    public func authAddr(authAddr:Address) ->SearchForAccounts{
        self.queryItems["auth-addr"]="\(authAddr.description)";
           return self;
       }

    public func currencyGreaterThan(currencyGreaterThan:Int64)->SearchForAccounts {
           self.queryItems["currency-greater-than"]="\(currencyGreaterThan)"
           return self;
       }

    public func currencyLessThan(currencyLessThan:Int64) ->SearchForAccounts{
           self.queryItems["currency-less-than"]="\(currencyLessThan)"
           return self;
       }

    public func limit(limit:Int64) ->SearchForAccounts{
           self.queryItems["limit"]="\(limit)"
           return self;
       }

    public func next(next:String)->SearchForAccounts {
           self.queryItems["next"] = next
           return self;
       }

    public func round(round:Int64) ->SearchForAccounts{
           self.queryItems["round"]="\(round)"
           return self;
       }



    internal func getUrlComponent() ->URLComponents{
        var component=client.connectString()
        component.path = component.path + "/v2/accounts"

//        return component.url!.absoluteString;
        return component;
    }

    func getRequestString()->String{
        self.urlComponent.setQueryItems(with: queryItems)
        return urlComponent.url!.absoluteString;
    }
}
