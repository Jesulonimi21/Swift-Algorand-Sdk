//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
import Alamofire

public class GetProof: Request {
    public typealias ResponseType = ProofResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, round: Int64, txId: String) {
        self.client=client
        parameters = .init(path: "/v2/blocks/\(round)/transactions/\(txId)/proof",
                           queryParameters: ["format": "msgpack"])
    }
}

// public class GetProof{
//    var client:AlgodClient
//    var txId:String
//    var round:Int64
//    init(client:AlgodClient,round:Int64,txId:String) {
//        self.client=client
//        self.round=round
//        self.txId = txId
//    }
//
//    public func execute( callback: @escaping (_:Response<ProofResponse>) ->Void){
////        print(getRequestString(parameter: self.round))
//        let headers:HTTPHeaders=[client.apiKey:client.token]
//        var request=AF.request(getRequestString(parameter: self.round),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//
//        request.validate()
//        var customResponse:Response<ProofResponse>=Response()
//
//
//        request.responseDecodable(of: ProofResponse.self){  (response) in
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
//
//                    let data=response.value
//                    var proofResponse:ProofResponse=data!
//                    customResponse.setData(data:proofResponse)
//                    customResponse.setIsSuccessful(value:true)
//                    callback(customResponse)
//
//    }
//    }
//
//    internal func getRequestString(parameter:Int64)->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/blocks/\(self.round)/transactions/\(self.txId)/proof"
//        component.setQueryItems(with: ["format":"msgpack"])
//        return component.url!.absoluteString;
//
//    }
// }
