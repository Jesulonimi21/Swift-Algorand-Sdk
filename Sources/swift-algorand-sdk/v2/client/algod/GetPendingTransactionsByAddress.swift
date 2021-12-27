//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
import Alamofire
public class GetPendingTransactionsByAddress{
    var client:AlgodClient

    var address:Address
    init(client:AlgodClient,address:Address) {
        self.client=client
        self.address=address
    }

    public func execute( callback: @escaping (_:Response<  PendingTransactionsResponse>) ->Void){
     
        let headers:HTTPHeaders=[client.apiKey:client.token]
        var request=AF.request(getRequestString(),method: .get, parameters: nil, headers: headers,requestModifier: { $0.timeoutInterval = 120 })
        request.validate()
        var customResponse:Response<PendingTransactionsResponse>=Response()
 
        print("pend requesturl = \(getRequestString())")
        print("pend headers = \(headers)")
        request.responseDecodable(of:  PendingTransactionsResponse.self){  (response) in
    
           
    if(response.error != nil){
        
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        if(response.data != nil){
            if let message = String(data: response.data!,encoding: .utf8){
                var errorDic = try! JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any]
                customResponse.errorMessage = errorDic!["message"] as! String
            }

        }
        return
    }
            //let str = String(decoding: response.value ?? Data(), as: UTF8.self)
            
                    let data=response.value
            print("pend data = \(data?.toJson())")
                    var pendingTransactionsResponse:PendingTransactionsResponse=data!
            let test = pendingTransactionsResponse.topTransactions?.first?.tx
            print("pend txID = \(test?.txID())")
                    customResponse.setData(data:pendingTransactionsResponse)
                    customResponse.setIsSuccessful(value:true)
                    callback(customResponse)

    }
    }

    internal func getRequestString()->String {
        var component=client.connectString()
        component.path = component.path+"/v2/accounts/\(address.description)/transactions/pending"
        return component.url!.absoluteString;
        
    }
}

