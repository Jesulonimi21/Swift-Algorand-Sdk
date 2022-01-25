//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
import Alamofire

public struct GetApplicationById: Request {
    public typealias ResponseType = Application
    public let client: HTTPClient
    public let parameters: RequestParameters
    
    init(client: AlgodClient, applicationId: Int64) {
        self.client=client
        self.parameters = .init(path: "/v2/applications/\(applicationId)")
    }
}
//
// public class GetApplicationById{
//    var client:AlgodClient
//
//    var applicationId:Int64
//    init(client:AlgodClient,applicationId:Int64) {
//        self.client=client
//        self.applicationId=applicationId
//
//    }
//
//    public func execute( callback: @escaping (_:Response<  Application>) ->Void){
////        print(getRequestString(parameter: self.applicationId))
//        let headers:HTTPHeaders=[client.apiKey:client.token]
//        var request=AF.request(getRequestString(parameter: self.applicationId),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//        request.validate()
//        var customResponse:Response<Application>=Response()
//
//
//        request.responseDecodable(of:  Application.self){  (response) in
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
//                    var applicationResponse:Application=data!
//                    customResponse.setData(data:applicationResponse)
//                    customResponse.setIsSuccessful(value:true)
//                    callback(customResponse)
//
//    }
//    }
//
//    internal func getRequestString(parameter:Int64)->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/applications/\(applicationId)"
//        return component.url!.absoluteString;
//
//    }
// }
