//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire

public class SearchForTransactions: Request {
    public typealias ResponseType = TransactionsResponse
    public let client: HTTPClient
    private var queryItems: [String: String] = [:] {
        didSet {
            parameters.queryParameters = queryItems
        }
    }
    public private(set) var parameters: RequestParameters
    
    init(client:IndexerClient,
         address:Address? = nil,
         applicationId:Int64? = nil,
         assetId:Int64? = nil,
         currencyGreaterThan:Int64? = nil,
         currencyLessThan:Int64? = nil,
         excludeCloseTo:Bool? = nil,
         limit: Int64? = nil,
         maxRound: Int64? = nil,
         minRound: Int64? = nil,
         next: String? = nil,
         notePrefix:Data? = nil,
         rekeyTo: Bool? = nil,
         round:Int64? = nil,
         txid:String? = nil ) {
        self.client = client
        parameters = .init(path: "/v2/transactions")
        let query: [String: CustomStringConvertible?]
        
        query = [
            "address": address?.description,
            "application-id": applicationId,
            "asset-id": assetId,
            "currency-greater-than": currencyGreaterThan,
            "currency-less-than": currencyLessThan,
            "exclude-close-to": excludeCloseTo,
            "limit": limit,
            "max-round": maxRound,
            "min-round": minRound,
            "next": next,
            "note-prefix": notePrefix,
            "rekey-to": rekeyTo,
            "round": round,
            "txid": txid
        ]
        queryItems = query.compactMapValues { $0?.description }
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
    
}
//
//public class SearchForTransactions  {
//    var client:IndexerClient
//    var urlComponent:URLComponents;
//    var queryItems:[String:String]=[:]
//    init(client:IndexerClient, address:Address? = nil, applicationId:Int64? = nil, assetId:Int64? = nil,
//         currencyGreaterThan:Int64? = nil,currencyLessThan:Int64? = nil, excludeCloseTo:Bool? = nil,
//         limit: Int64? = nil, maxRound: Int64? = nil, minRound: Int64? = nil, next: String? = nil,
//         notePrefix:Data? = nil, rekeyTo: Bool? = nil, round:Int64? = nil, txid:String? = nil ) {
//        self.client=client
//        self.urlComponent=client.connectString()
//        urlComponent.path = urlComponent.path + "/v2/transactions"
//
//        if let uAddress = address{
//            self.queryItems["address"] = uAddress.description
//        }
//        if let uApplicationId = applicationId{
//            self.queryItems["application-id"] = "\(uApplicationId)"
//        }
//        if let uAssetId = assetId{
//            self.queryItems["asset-id"]="\(uAssetId)"
//        }
//
//        if let uCurrencyGreaterThan = currencyGreaterThan{
//            self.queryItems["currency-greater-than"] = "\(uCurrencyGreaterThan)"
//        }
//
//        if let uCurrencyLessThan = currencyLessThan{
//            self.queryItems["currency-less-than"] = "\(uCurrencyLessThan)"
//        }
//
//        if let uExcludeCloseTo = excludeCloseTo{
//            self.queryItems["exclude-close-to"] = "\(uExcludeCloseTo)"
//        }
//
//        if let uLimit = limit{
//            self.queryItems["limit"] = "\(uLimit)"
//        }
//
//        if let uMaxRound = maxRound{
//            self.queryItems["max-round"]="\(uMaxRound)"
//        }
//
//        if let uMinRound = minRound{
//            self.queryItems["min-round"]="\(uMinRound)"
//        }
//
//        if let uNext = next{
//            self.queryItems["next"] = next
//        }
//
//        if let uNotePrefix = notePrefix{
//            self.queryItems["note-prefix"] = CustomEncoder.encodeToBase64(uNotePrefix);
//        }
//
//        if let uRekeyTo = rekeyTo{
//            self.queryItems["rekey-to"] = "\(rekeyTo)"
//        }
//
//        if let uRound = round{
//            self.queryItems["round"] = "\(uRound)";
//        }
//
//        if let uTxid = txid{
//            self.queryItems["txid"] = txid
//        }
//
//
//    }
//    public func execute( callback: @escaping (_:Response<TransactionsResponse>)->Void) {
//        let headers:HTTPHeaders=[client.apiKey:client.token]
////        print(getRequestString())
//        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.responseJSON(){response in
//            debugPrint(response.value)
//        }
//        var customResponse:Response<TransactionsResponse>=Response()
//      request.responseDecodable(of: TransactionsResponse.self){ (response) in
//        if(response.error != nil){
//            customResponse.setIsSuccessful(value:false)
//            var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
//            customResponse.setErrorDescription(errorDescription:errorDescription!)
//            callback(customResponse)
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
//                        var transactionsResponse:TransactionsResponse=data!
//                        customResponse.setData(data:transactionsResponse)
//                        customResponse.setIsSuccessful(value:true)
//                        callback(customResponse)
//
//        }
//
//    }
//    public func address(address:Address) ->SearchForTransactions{
//        self.queryItems["address"] = address.description
//        return self;
//        }
//
//    public func applicationId(applicationId:Int64)->SearchForTransactions {
//        self.queryItems["application-id"] = "\(applicationId)"
//            return self;
//        }
//
//    public func assetId(assetId:Int64)->SearchForTransactions {
//        self.queryItems["asset-id"]="\(assetId)"
//            return self;
//        }
//
//    public func currencyGreaterThan(currencyGreaterThan:Int64)->SearchForTransactions {
//        self.queryItems["currency-greater-than"] = "\(currencyGreaterThan)"
//            return self;
//        }
//
//    public func currencyLessThan( currencyLessThan:Int64)->SearchForTransactions {
//            self.queryItems["currency-less-than"] = "\(currencyLessThan)"
//            return self
//        }
//
//    public func excludeCloseTo(excludeCloseTo:Bool)->SearchForTransactions {
//        self.queryItems["exclude-close-to"] = "\(excludeCloseTo)"
//            return self
//        }
//
//    public func limit(limit:Int64)->SearchForTransactions {
//            self.queryItems["limit"] = "\(limit)"
//            return self
//        }
//
//    public func maxRound(maxRound:Int64) ->SearchForTransactions{
//            self.queryItems["max-round"]="\(maxRound)"
//            return self
//        }
//
//    public func minRound(minRound:Int64) ->SearchForTransactions{
//            self.queryItems["min-round"] = "\(minRound)"
//        return self
//        }
//
//    public func next(next:String)->SearchForTransactions {
//            self.queryItems["next"] = next
//            return self;
//        }
//
//    public func notePrefix(notePrefix:Data)->SearchForTransactions {
//            self.queryItems["note-prefix"] = CustomEncoder.encodeToBase64(notePrefix);
//            return self;
//        }
//
//    public func rekeyTo(rekeyTo:Bool)->SearchForTransactions {
//            self.queryItems["rekey-to"] = "\(rekeyTo)"
//            return self;
//        }
//
//
//    public func round(round:Int64)->SearchForTransactions {
//        self.queryItems["round"] = "\(round)";
//            return self;
//        }
//
//
//
//
//    public func txid( txid:String)->SearchForTransactions {
//            self.queryItems["txid"] = txid
//            return self;
//        }
//
//
//    internal func getUrlComponent() ->URLComponents{
//        var component=client.connectString()
//        component.path = component.path + "/v2/transactions"
//        return component;
//    }
//
//    func getRequestString()->String{
//        self.urlComponent.setQueryItems(with: queryItems)
//        return urlComponent.url!.absoluteString;
//    }
//}
