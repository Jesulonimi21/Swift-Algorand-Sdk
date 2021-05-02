//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/1/21.
//

import Foundation
import Alamofire
public class TealCompile{
    var client:AlgodClient
    var source:[Int8]?
    init(client:AlgodClient) {
        self.client=client
    }

    public func source(source:[Int8]) ->TealCompile {
        self.source=source
        return self;
    }

    public func execute( callback: @escaping (_:Response<CompileResponse>) ->Void){
//        print(getRequestString())
        let headers:HTTPHeaders=[client.apiKey:client.token,"Content-type":"application/x-binary"]
        var request=AF.request(getRequestString(),method: .post, parameters: nil, encoding: ByteEncoding(data:Data(CustomEncoder.convertToUInt8Array(input: self.source!))), headers: headers,requestModifier: { $0.timeoutInterval = 120 })
        
//        request.responseJSON(){response in
//            debugPrint(response.value)
//            print("response json")
//        }
        request.validate()
        var customResponse:Response<CompileResponse>=Response()
             
  request.responseDecodable(of: CompileResponse.self){  (response) in
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
    
    customResponse.setIsSuccessful(value:true)
                    let data=response.value
                    var compileResponse:CompileResponse=data!
                    customResponse.setData(data:compileResponse)
                    callback(customResponse)

    }
    }

    internal func getRequestString()->String {
        var component=client.connectString()
        component.path = component.path+"/v2/teal/compile"
        return component.url!.absoluteString;
        
    }
}
