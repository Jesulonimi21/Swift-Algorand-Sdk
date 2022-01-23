//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire
public class SearchForTransactions  {
    var client:IndexerClient
    var urlComponent:URLComponents;
    var queryItems:[String:String]=[:]
    init(client:IndexerClient, address:Address? = nil, applicationId:Int64? = nil, assetId:Int64? = nil,
         currencyGreaterThan:Int64? = nil,currencyLessThan:Int64? = nil, excludeCloseTo:Bool? = nil,
         limit: Int64? = nil, maxRound: Int64? = nil, minRound: Int64? = nil, next: String? = nil,
         notePrefix:Data? = nil, rekeyTo: Bool? = nil, round:Int64? = nil, txid:String? = nil ) {
        self.client=client
        self.urlComponent=client.connectString()
        urlComponent.path = urlComponent.path + "/v2/transactions"
        
        if let uAddress = address{
            self.queryItems["address"] = uAddress.description
        }
        if let uApplicationId = applicationId{
            self.queryItems["application-id"] = "\(uApplicationId)"
        }
        if let uAssetId = assetId{
            self.queryItems["asset-id"]="\(uAssetId)"
        }
        
        if let uCurrencyGreaterThan = currencyGreaterThan{
            self.queryItems["currency-greater-than"] = "\(uCurrencyGreaterThan)"
        }
        
        if let uCurrencyLessThan = currencyLessThan{
            self.queryItems["currency-less-than"] = "\(uCurrencyLessThan)"
        }
        
        if let uExcludeCloseTo = excludeCloseTo{
            self.queryItems["exclude-close-to"] = "\(uExcludeCloseTo)"
        }
        
        if let uLimit = limit{
            self.queryItems["limit"] = "\(uLimit)"
        }
        
        if let uMaxRound = maxRound{
            self.queryItems["max-round"]="\(uMaxRound)"
        }
        
        if let uMinRound = minRound{
            self.queryItems["min-round"]="\(uMinRound)"
        }
        
        if let uNext = next{
            self.queryItems["next"] = next
        }
        
        if let uNotePrefix = notePrefix{
            self.queryItems["note-prefix"] = CustomEncoder.encodeToBase64(uNotePrefix);
        }
        
        if let uRekeyTo = rekeyTo{
            self.queryItems["rekey-to"] = "\(rekeyTo)"
        }
        
        if let uRound = round{
            self.queryItems["round"] = "\(uRound)";
        }
        
        if let uTxid = txid{
            self.queryItems["txid"] = txid
        }
      
        
    }
    public func execute( callback: @escaping (_:Response<TransactionsResponse>)->Void) {
        let headers:HTTPHeaders=[client.apiKey:client.token]
//        print(getRequestString())
        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
        request.responseJSON(){response in
            debugPrint(response.value)
        }
        var customResponse:Response<TransactionsResponse>=Response()
      request.responseDecodable(of: TransactionsResponse.self){ (response) in
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
                        var transactionsResponse:TransactionsResponse=data!
                        customResponse.setData(data:transactionsResponse)
                        customResponse.setIsSuccessful(value:true)
                        callback(customResponse)

        }
        
       
   
        
    }
    
    
    internal func getUrlComponent() ->URLComponents{
        var component=client.connectString()
        component.path = component.path + "/v2/transactions"
        return component;
    }
    
    func getRequestString()->String{
        self.urlComponent.setQueryItems(with: queryItems)
        return urlComponent.url!.absoluteString;
    }
}
