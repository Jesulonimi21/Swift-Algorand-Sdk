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
    init(client:IndexerClient) {
        self.client=client
        self.urlComponent=client.connectString()
        urlComponent.path = urlComponent.path + "/v2/transactions"

    }
    public func execute( callback: @escaping (_:Response<TransactionsResponse>)->Void) {
        let headers:HTTPHeaders=[client.apiKey:client.token]
        print(getRequestString())
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
            return
        }
                        let data=response.value
                        var transactionsResponse:TransactionsResponse=data!
                        customResponse.setData(data:transactionsResponse)
                        customResponse.setIsSuccessful(value:true)
                        callback(customResponse)

        }
        
       
   
        
    }


    
  
    
    public func address(address:Address) ->SearchForTransactions{
        self.queryItems["address"] = address.description
        return self;
        }

    public func applicationId(applicationId:Int64)->SearchForTransactions {
        self.queryItems["application-id"] = "\(applicationId)"
            return self;
        }

    public func assetId(assetId:Int64)->SearchForTransactions {
        self.queryItems["asset-id"]="\(assetId)"
            return self;
        }

    public func currencyGreaterThan(currencyGreaterThan:Int64)->SearchForTransactions {
        self.queryItems["currency-greater-than"] = "\(currencyGreaterThan)"
            return self;
        }

    public func currencyLessThan( currencyLessThan:Int64)->SearchForTransactions {
            self.queryItems["currency-less-than"] = "\(currencyLessThan)"
            return self
        }

    public func excludeCloseTo(excludeCloseTo:Bool)->SearchForTransactions {
        self.queryItems["exclude-close-to"] = "\(excludeCloseTo)"
            return self
        }

    public func limit(limit:Int64)->SearchForTransactions {
            self.queryItems["limit"] = "\(limit)"
            return self
        }

    public func maxRound(maxRound:Int64) ->SearchForTransactions{
            self.queryItems["max-round"]="\(maxRound)"
            return self
        }

    public func minRound(minRound:Int64) ->SearchForTransactions{
            self.queryItems["min-round"] = "\(minRound)"
        return self
        }

    public func next(next:String)->SearchForTransactions {
            self.queryItems["next"] = next
            return self;
        }

    public func notePrefix(notePrefix:Data)->SearchForTransactions {
            self.queryItems["note-prefix"] = CustomEncoder.encodeToBase64(notePrefix);
            return self;
        }

    public func rekeyTo(rekeyTo:Bool)->SearchForTransactions {
            self.queryItems["rekey-to"] = "\(rekeyTo)"
            return self;
        }

    
    public func round(round:Int64)->SearchForTransactions {
        self.queryItems["round"] = "\(round)";
            return self;
        }

        

      
    public func txid( txid:String)->SearchForTransactions {
            self.queryItems["txid"] = txid
            return self;
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
