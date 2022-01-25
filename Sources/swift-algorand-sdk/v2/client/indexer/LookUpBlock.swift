//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
import Alamofire

public struct LookupBlock: Request {
    
    public typealias ResponseType = Block
    public let client: HTTPClient
    public var parameters: RequestParameters
    
    init(client:IndexerClient, roundNumber:Int64) {
        self.client = client
        parameters = .init(path: "/v2/blocks/\(roundNumber)")
    }
}
//
//public class LookupBlock{
//    var client:IndexerClient
//    var rawTransaction:[Int8]?
//    var roundNumber:Int64
//    init(client:IndexerClient,roundNumber:Int64) {
//        self.client=client
//        self.roundNumber=roundNumber
//    }
//
//    public func execute( callback: @escaping (_:Response<Block>) ->Void){
////        print(getRequestString(parameter: self.roundNumber))
//        let headers:HTTPHeaders=[client.apiKey:client.token]
//        var request=AF.request(getRequestString(parameter: self.roundNumber),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.validate()
//        var customResponse:Response<Block>=Response()
////        request.responseJSON(){response in
////            debugPrint(response.value)
////        }
//  request.responseDecodable(of: Block.self){  (response) in
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
//
//            }
//
//        }
//        return
//    }
//                    let data=response.value
//                    var block:    Block=data!
//                    customResponse.setData(data:block)
//                    customResponse.setIsSuccessful(value:true)
//                    callback(customResponse)
//
//    }
//    }
//
//    internal func getRequestString(parameter:Int64)->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/blocks/\(parameter)"
//        return component.url!.absoluteString;
//
//    }
//}
