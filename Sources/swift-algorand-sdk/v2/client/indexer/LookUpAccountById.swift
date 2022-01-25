//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire

public struct LookUpAccountById: Request {
    public typealias ResponseType = AccountResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    init(client:IndexerClient, address:String) {
        self.client=client
        self.parameters = .init(path: "/v2/accounts/\(address)")
    }
}
//
//public class LookUpAccountById{
//    var client:IndexerClient
//    var rawTransaction:[Int8]?
//    var address:String
//    init(client:IndexerClient,address:String) {
//        self.client=client
//        self.address=address
//    }
//
//    public func execute( callback: @escaping (_:Response<AccountResponse>) ->Void){
//        let headers:HTTPHeaders=[client.apiKey:client.token]
//        var request=AF.request(getRequestString(parameter: self.address),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//
//        request.validate()
//        var customResponse:Response<AccountResponse>=Response()
//        request.responseDecodable(of: AccountResponse.self){  (response) in
//
//    if(response.error != nil){
//        print(response.error)
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
//                    var accountResponse:    AccountResponse=data!
//                    customResponse.setData(data:accountResponse)
//                    customResponse.setIsSuccessful(value:true)
//                    callback(customResponse)
//
//    }
//    }
//
//    internal func getRequestString(parameter:String)->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/accounts/\(parameter)"
//        return component.url!.absoluteString;
//
//    }
//}
