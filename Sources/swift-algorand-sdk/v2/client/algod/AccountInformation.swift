//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/15/21.
//


import Foundation
import Alamofire
public class AccountInformation{
    var client:AlgodClient
    var rawTransaction:[Int8]?
    var address:String
    init(client:AlgodClient,address:String) {
        self.client=client
        self.address=address
    }

    public func execute( callback: @escaping (_:Response<AccountData>) ->Void){
//        print(getRequestString(parameter: self.address))
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(parameter: self.address),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })

        request.validate()
        var customResponse:Response<AccountData>=Response()
  request.responseDecodable(of: AccountData.self){  (response) in

    if(response.error != nil){
        
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        return
    }
    
                    
                    let data=response.value
                    var accountData:AccountData=data!
                    customResponse.setData(data:accountData)
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

