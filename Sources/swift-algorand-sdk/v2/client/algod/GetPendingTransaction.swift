//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
import Alamofire

public class GetPendingTransactions: Request {
    
    public typealias ResponseType = PendingTransactionResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        self.parameters = .init(path: "/v2/transactions/pending",
                                queryParameters: ["max": "0"])
    }
}
// public class GetPendingTransactions  {
//    var client:AlgodClient
//    init(client:AlgodClient) {
//        self.client=client
//    }
//
//    public func execute( callback: @escaping (_:Response<PendingTransactionsResponse>)->Void) {
//
//
//        let headers:HTTPHeaders=[client.apiKey:client.token]
////        print(getRequestString())
//        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        var customResponse:Response<PendingTransactionsResponse>=Response()
//      request.responseDecodable(of: PendingTransactionsResponse.self){ (response) in
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
//                        var transactionsResponse:PendingTransactionsResponse=data!
//                        customResponse.setData(data:transactionsResponse)
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
//        component.path = component.path + "/v2/transactions/pending"
//        component.setQueryItems(with: ["max":"0"])
//        return component.url!.absoluteString;
//    }
// }
