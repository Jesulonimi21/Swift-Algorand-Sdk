//
//  File.swift
//
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
import Alamofire
public class LookUpAccountById{
    var client:IndexerClient
    var rawTransaction:[Int8]?
    var address:String
    init(client:IndexerClient,address:String) {
        self.client=client
        self.address=address
    }

    public func execute( callback: @escaping (_:Response<AccountResponse>) ->Void){
        print(getRequestString(parameter: self.address))
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(parameter: self.address),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })

        request.validate()
        
//        request.responseJSON(){response in
//            debugPrint(response.value)
//        }
        var customResponse:Response<AccountResponse>=Response()
        request.responseDecodable(of: AccountResponse.self){  (response) in

    if(response.error != nil){
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        return
    }
                    let data=response.value
                    var accountResponse:    AccountResponse=data!
                    customResponse.setData(data:accountResponse)
                    customResponse.setIsSuccessful(value:true)
                    callback(customResponse)

    }
    }

    internal func getRequestString(parameter:String)->String {
        var component=client.connectString()
        component.path = component.path+"/v2/accounts/\(parameter)"
        return component.url!.absoluteString;
        
    }
}
