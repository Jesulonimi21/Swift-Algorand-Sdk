//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation


public struct GetSupply: Request {
    public typealias ResponseType = SupplyResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "/v2/ledger/supply")
    }
}
//

// public class GetSupply  {
//    var client:AlgodClient
//    init(client:AlgodClient) {
//        self.client=client
//    }
////
//    public func execute( callback: @escaping (_:Response<SupplyResponse>)->Void) {
//
//
//        let headers:HTTPHeaders=[client.apiKey:client.token]
////        print(getRequestString())
//        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        var customResponse:Response<SupplyResponse>=Response()
//      request.responseDecodable(of: SupplyResponse.self){ (response) in
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
//                        var supplyResponse:SupplyResponse=data!
//                        customResponse.setData(data:supplyResponse)
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
//        component.path = component.path + "/v2/ledger/supply"
//
//        return component.url!.absoluteString;
//    }
// }
