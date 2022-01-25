//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
import Alamofire

public class GetPendingTransactionsByAddress: Request {
    
    public typealias ResponseType = PendingTransactionResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, address: Address) {
        self.client = client
        self.parameters = .init(path: "/v2/accounts/\(address.description)/transactions/pending")
    }
}
//public class GetPendingTransactionsByAddress{
//    var client:AlgodClient
//
//    var address:Address
//    init(client:AlgodClient,address:Address) {
//        self.client=client
//        self.address=address
//    }
//
//    public func execute( callback: @escaping (_:Response<  PendingTransactionsResponse>) ->Void){
//
//        let headers:HTTPHeaders=[client.apiKey:client.token]
//        var request=AF.request(getRequestString(),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.validate()
//        var customResponse:Response<PendingTransactionsResponse>=Response()
//
//
//        request.responseDecodable(of:  PendingTransactionsResponse.self){  (response) in
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
//                    var pendingTransactionsResponse:PendingTransactionsResponse=data!
//                    customResponse.setData(data:pendingTransactionsResponse)
//                    customResponse.setIsSuccessful(value:true)
//                    callback(customResponse)
//
//    }
//    }
//
//    internal func getRequestString()->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/accounts/\(address.description)/transactions/pending"
//        return component.url!.absoluteString;
//
//    }
//}
//
