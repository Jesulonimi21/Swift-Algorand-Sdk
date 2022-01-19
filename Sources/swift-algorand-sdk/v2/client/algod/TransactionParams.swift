//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/9/21.
//

import Foundation
import Alamofire

public struct TransactionParams: Request {
    public typealias ResponseType = TransactionParametersResponse
    public let client: AlgodClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "/v2/transactions/params")
    }
}

//public class TransactionParams  {
//    var client:AlgodClient
//    init(client:AlgodClient) {
//        self.client=client
//    }
////
//    public func execute( callback: @escaping (_:Response<TransactionParametersResponse>)->Void) {
//
//        let group=DispatchGroup()
//        let headers:HTTPHeaders=[client.apiKey:client.token]
//        print(getRequestString())
//        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        var customResponse:Response<TransactionParametersResponse>=Response()
//      request.responseDecodable(of: TransactionParametersResponse.self){ (response) in
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
//                        var transactionParameterResponse:TransactionParametersResponse=data!
//                        customResponse.setData(data:transactionParameterResponse)
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
//        component.path = component.path + "/v2/transactions/params"
//
//        return component.url!.absoluteString;
//    }
//}
