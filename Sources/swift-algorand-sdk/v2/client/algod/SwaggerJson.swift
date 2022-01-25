//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
import Alamofire

// TODO: is this really needed? Swagger in a Swift application?
public class SwaggerJson {
    var client: AlgodClient
    init(client: AlgodClient) {
        self.client=client
    }
//
    public func execute( callback: @escaping (_:Response<String>) -> Void) {
    
        let headers: HTTPHeaders=[client.apiKey: client.token]
        
        var request=AF.request(getRequestString(), method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 120 })
        var customResponse: Response<String>=Response()
//      request.responseDecodable(of: String.self){ (response) in
//        if(response.error != nil){
//            customResponse.setIsSuccessful(value:false)
//            var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
//            customResponse.setErrorDescription(errorDescription:errorDescription!)
//            print(response.error)
//            callback(customResponse)
//            if(response.data != nil){
//                if let message = String(data: response.data!,encoding: .utf8){
//                    var errorDic = try! JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any]
//
//                    customResponse.errorMessage = errorDic!["message"] as! String
//                }
//            }
//            return
//        }
//                        let data=response.value
//
//        customResponse.setData(data: (data ?? "nil") ?? "nil")
//                        customResponse.setIsSuccessful(value:true)
//                        callback(customResponse)
//
//        }
        request.responseJSON {response in
//            print(String(bytes: response.data!,encoding: .utf8))
            switch response.result {
            case .success: customResponse.setData(data: String(bytes: response.data!, encoding: .utf8) ?? "nil")
                customResponse.setIsSuccessful(value: true)
                callback(customResponse)
            case .failure(let error): customResponse.setErrorDescription(errorDescription: error.localizedDescription)
                customResponse.setIsSuccessful(value: false)
                callback(customResponse)
            }
        }
        
    }

    internal func getRequestString() -> String {
        var component=client.connectString()
        component.path = component.path + "/swagger.json"

        return component.url!.absoluteString
    }
}
