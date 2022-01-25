//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire

public struct SearchForApplications: Request {
    public typealias ResponseType = ApplicationsResponse
    public let client: HTTPClient
    public let parameters: RequestParameters
    init(client: IndexerClient) {
        self.client = client
        parameters = .init(path: "/v2/applications")
    }
}

//public class SearchForApplications  {
//    var client:IndexerClient
//    init(client:IndexerClient) {
//        self.client=client
//    }
//    public func execute( callback: @escaping (_:Response<ApplicationsResponse>)->Void) {
//
//        let headers:HTTPHeaders=[client.apiKey:client.token]
////        print(getRequestString())
//        var request=AF.request(getRequestString(), method: .get, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
////        request.responseJSON(){response in
////            debugPrint(response.value)
////        }
//
//        var customResponse:Response<ApplicationsResponse>=Response()
//      request.responseDecodable(of: ApplicationsResponse.self){ (response) in
//        if(response.error != nil){
//            customResponse.setIsSuccessful(value:false)
//            var errorDescription=String(data: Data(response.error!.errorDescription!.utf8),encoding: .utf8)
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
//                        var applicationsResponse:ApplicationsResponse=data!
//                        customResponse.setData(data:applicationsResponse)
//                        customResponse.setIsSuccessful(value:true)
//                        callback(customResponse)
//
//        }
//
//
//
//
//    }
//
//
//
//
//    internal func getRequestString() ->String{
//        var component=client.connectString()
//        component.path = component.path + "/v2/applications"
//
//        return component.url!.absoluteString;
//    }
//}
