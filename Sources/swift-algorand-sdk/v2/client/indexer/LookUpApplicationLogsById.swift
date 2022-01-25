//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 19/01/2022.
//

import Foundation
import Alamofire

public struct LookUpApplicationLogsById: Request {
    public typealias ResponseType = ApplicationLogResponse
    
    public let client: HTTPClient
    
    public let parameters: RequestParameters
        init(client:IndexerClient,
             applicationId:Int64,
             limit:Int64? = nil,
             maxRound:Int64? = nil,
             minRound:Int64? = nil,
             next:String? = nil,
             senderAddress:Address? = nil,
             txid:String? = nil ) {
            self.client = client
            let queryParameters: [String: CustomStringConvertible?] = [
                "limit": limit,
                "maxRound": maxRound,
                "minRound": minRound,
                "next": next,
                "senderAddress": senderAddress?.description,
                "txid": txid
            ]
            parameters = .init(path: "/v2/applications/\(applicationId)/logs",
                               queryParameters:
                                queryParameters.compactMapValues { $0?.description })
        }
}

//
//public class LookUpApplicationLogsById{
//    var client:IndexerClient
//    var rawTransaction:[Int8]?
//    var applicationId:Int64
//    var queryItems:[String:String]=[:]
//
//
//
//
//    init(client:IndexerClient,applicationId:Int64, limit:Int64? = nil, maxRound:Int64? = nil,
//         minRound:Int64? = nil, next:String? = nil, senderAddress:Address? = nil, txid:String? = nil ) {
//        self.client=client
//        self.applicationId = applicationId
//        if let uLimit = limit{
//            self.queryItems["limit"] = "\(uLimit)"
//        }
//        if let uMaxRound = maxRound{
//            self.queryItems["maxRound"] = "\(uMaxRound)"
//        }
//        if let uMinRound = minRound{
//            self.queryItems["minRound"] = "\(uMinRound)"
//        }
//        if let uNext = next{
//            self.queryItems["next"] = uNext
//        }
//        if let uSenderAddress = senderAddress{
//            self.queryItems["senderAddress"] = uSenderAddress.description
//        }
//        if let uTxid = txid{
//            self.queryItems["txid"] = uTxid
//        }
//
//    }
//
//    public func execute( callback: @escaping (_:Response<ApplicationLogResponse>) ->Void){
//
//        let headers:HTTPHeaders=[client.apiKey:client.token]
//        var request=AF.request(getRequestString(parameter: self.applicationId),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.validate()
//        var customResponse:Response<ApplicationLogResponse>=Response()
//  request.responseDecodable(of: ApplicationLogResponse.self){  (response) in
//
//    if(response.error != nil){
//        customResponse.setIsSuccessful(value:false)
//        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
//        customResponse.setErrorDescription(errorDescription:errorDescription!)
//        callback(customResponse)
//        if(response.data != nil){
//            if let message = String(data: response.data!,encoding: .utf8){
//                var errorDic = try! JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any]
//                customResponse.errorMessage = errorDic!["message"] as! String
//            }
//        }
//        return
//    }
//                    let data=response.value
//                    var applicationLogResponse:ApplicationLogResponse=data!
//                    customResponse.setData(data:applicationLogResponse)
//                    customResponse.setIsSuccessful(value:true)
//                    callback(customResponse)
//
//    }
//    }
//
//    public func limit(limit:Int64) ->LookUpApplicationLogsById{
//        self.queryItems["limit"] = "\(limit)"
//        return self;
//        }
//    public func maxRound(maxRound:Int64) ->LookUpApplicationLogsById{
//        self.queryItems["maxRound"] = "\(maxRound)"
//        return self;
//        }
//
//    public func minRound(minRound:Int64) ->LookUpApplicationLogsById{
//        self.queryItems["minRound"] = "\(minRound)"
//        return self;
//        }
//
//    public func next(next:String) ->LookUpApplicationLogsById{
//        self.queryItems["next"] = next
//        return self;
//        }
//
//
//    public func senderAddress(senderAddress:Address) ->LookUpApplicationLogsById{
//        self.queryItems["senderAddress"] = senderAddress.description
//        return self;
//        }
//
//    public func txid(txid:String) ->LookUpApplicationLogsById{
//        self.queryItems["txid"] = txid
//        return self;
//        }
//
//
//
//    internal func getRequestString(parameter:Int64)->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/applications/\(parameter)/logs"
//        component.setQueryItems(with: self.queryItems)
//        return component.url!.absoluteString;
//    }
//
//
//    //TODO: IMPLEMENT OTHER ways to query including limit and the likes
//}
