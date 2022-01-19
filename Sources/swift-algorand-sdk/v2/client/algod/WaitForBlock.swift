//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//


import Foundation
import Alamofire

public struct WaitForBlock: Request {
    public typealias ResponseType = NodeStatusResponse
    public let client: AlgodClient
    public let parameters: RequestParameters
    
    init(client:AlgodClient,round:Int64) {
        self.client=client
        parameters = .init(path: "/v2/status/wait-for-block-after/\(round)")
        
    }
    
}

//public class WaitForBlock{
//    var client:AlgodClient
//
//    var round:Int64
//    init(client:AlgodClient,round:Int64) {
//        self.client=client
//        self.round=round
//
//    }
//
//    public func execute( callback: @escaping (_:Response<  NodeStatusResponse>) ->Void){
////        print(getRequestString(parameter: self.round))
//        let headers:HTTPHeaders=[client.apiKey:client.token]
//        var request=AF.request(getRequestString(parameter: self.round),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.validate()
//        var customResponse:Response<NodeStatusResponse>=Response()
//
//
//        request.responseDecodable(of:  NodeStatusResponse.self){  (response) in
//
//    if(response.error != nil){
//
//        customResponse.setIsSuccessful(value:false)
//        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
//        customResponse.setErrorDescription(errorDescription:errorDescription!)
//        callback(customResponse)
//        if(response.data != nil){
//            if let message = String(data: response.data!,encoding: .utf8){
//                var errorDic = try! JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any]
//                customResponse.errorMessage = errorDic!["message"] as! String
//            }
//
//        }
//        return
//    }
//
//                    let data=response.value
//                    var nodeStatusResponse:NodeStatusResponse=data!
//                    customResponse.setData(data:nodeStatusResponse)
//                    customResponse.setIsSuccessful(value:true)
//                    callback(customResponse)
//
//    }
//    }
//
//    internal func getRequestString(parameter:Int64)->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/status/wait-for-block-after/\(round)"
//        return component.url!.absoluteString;
//
//    }
//}
