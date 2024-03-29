//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation

public struct AlgodHealthCheck: Request {
    
    public typealias ResponseType = String?
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "/health")
    }
}

// public class AlgodHealthCheck  {
//    var client:AlgodClient
//    init(client:AlgodClient) {
//        self.client=client
//    }
////
//    public func execute( callback: @escaping (_:Response<String>)->Void) {
//
//
//        let headers:HTTPHeaders=[client.apiKey:client.token]
////        print(getRequestString())
//        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        var customResponse:Response<String>=Response()
//      request.responseDecodable(of: String?.self){ (response) in
//        if(response.error != nil){
//            customResponse.setIsSuccessful(value:false)
//            var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
//            customResponse.setErrorDescription(errorDescription:errorDescription!)
//            print(response.error)
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
////
//        customResponse.setData(data: (data ?? "nil") ?? "nil")
//                        customResponse.setIsSuccessful(value:true)
//                        callback(customResponse)
//
//        }
//
//
//    }
//
//
//    internal func getRequestString() ->String{
//        var component=client.connectString()
//        component.path = component.path + "/health"
//
//        return component.url!.absoluteString;
//    }
// }
