//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
import Alamofire
public class LookUpAssetTransactions  {
    var client:IndexerClient
    var urlComponent:URLComponents;
    var queryItems:[String:String]=[:]
    var assetId:Int64
    
    
    
    init(client:IndexerClient, assetId:Int64, address:Address? = nil, currencyGreaterThan:Int64? = nil, currencyLessThan:Int64? = nil,
         excludeCloseTo:Bool? = nil, limit:Int64? = nil, maxRound:Int64? = nil, minRound:Int64? = nil, next:String? = nil, notePrefix:Data? = nil, rekeyTo:Bool? = nil, round:Int64? = nil, txid:String? = nil  ) {
        self.assetId=assetId
        self.client=client
        self.urlComponent=client.connectString()
        urlComponent.path = urlComponent.path + "/v2/assets/\(assetId)/transactions"
        if let uAddress = address{
            self.queryItems["address"] = uAddress.description
        }
        if let uCurrencyGreaterThan = currencyGreaterThan{
            self.queryItems["currency-greater-than"] = "\(uCurrencyGreaterThan)"
        }
        if let uCurrencyLessThan = currencyLessThan{
            self.queryItems["currency-less-than"] = "\(currencyLessThan)"
        }
        if let uExcludeCloseTo = excludeCloseTo{
            self.queryItems["exclude-close-to"] = "\(excludeCloseTo)"
        }
        if let uLimit = limit{
            self.queryItems["limit"] = "\(uLimit)"
        }
        if let uMaxRound = maxRound{
            self.queryItems["max-round"]="\(uMaxRound)"
        }
        if let uMinRound = minRound{
            self.queryItems["min-round"] = "\(uMinRound)"
        }
        if let uNext = next{
            self.queryItems["next"] = uNext
        }
        if let uNotePrefix = notePrefix{
            self.queryItems["note-prefix"] = CustomEncoder.encodeToBase64(uNotePrefix);
        }
        if let uRekeyTo = rekeyTo{
            self.queryItems["rekey-to"] = "\(uRekeyTo)"
        }
        if let uRound = round{
            self.queryItems["round"] = "\(uRound)";
        }
        if let uTxId = txid{
            self.queryItems["txid"] = uTxId
        }
        
    }
    public func execute( callback: @escaping (_:Response<TransactionsResponse>)->Void) {
    
        let headers:HTTPHeaders=[client.apiKey:client.token]
//        print(getRequestString())
        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.responseJSON(){response in
//            debugPrint(response.value)
//        }
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
    public func address(address:Address) ->LookUpAssetTransactions{
        self.queryItems["address"] = address.description
        return self;
        }

    

    public func currencyGreaterThan(currencyGreaterThan:Int64)->LookUpAssetTransactions {
        self.queryItems["currency-greater-than"] = "\(currencyGreaterThan)"
            return self;
        }

    public func currencyLessThan( currencyLessThan:Int64)->LookUpAssetTransactions {
            self.queryItems["currency-less-than"] = "\(currencyLessThan)"
            return self
        }

    public func excludeCloseTo(excludeCloseTo:Bool)->LookUpAssetTransactions {
        self.queryItems["exclude-close-to"] = "\(excludeCloseTo)"
            return self
        }

    public func limit(limit:Int64)->LookUpAssetTransactions {
            self.queryItems["limit"] = "\(limit)"
            return self
        }

    public func maxRound(maxRound:Int64) ->LookUpAssetTransactions{
            self.queryItems["max-round"]="\(maxRound)"
            return self
        }

    public func minRound(minRound:Int64) ->LookUpAssetTransactions{
            self.queryItems["min-round"] = "\(minRound)"
        return self
        }

    public func next(next:String)->LookUpAssetTransactions {
            self.queryItems["next"] = next
            return self;
        }

    public func notePrefix(notePrefix:Data)->LookUpAssetTransactions {
            self.queryItems["note-prefix"] = CustomEncoder.encodeToBase64(notePrefix);
            return self;
        }

    public func rekeyTo(rekeyTo:Bool)->LookUpAssetTransactions {
            self.queryItems["rekey-to"] = "\(rekeyTo)"
            return self;
        }

    
    public func round(round:Int64)->LookUpAssetTransactions {
        self.queryItems["round"] = "\(round)";
            return self;
        }

    public func txid( txid:String)->LookUpAssetTransactions {
            self.queryItems["txid"] = txid
            return self;
        }

    

    
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
