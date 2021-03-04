//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/10/21.
//

import Foundation
import Alamofire

struct ByteEncoding: ParameterEncoding {
  private let data: Data

  init(data: Data) {
    self.data = data
  }

  func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    var urlRequest = try urlRequest.asURLRequest()
    urlRequest.httpBody = data
    return urlRequest
  }
}
public class RawTransaction{
    var client:AlgodClient
    var rawTransaction:[Int8]?
    init(client:AlgodClient) {
        self.client=client
    }

    public func rawtxn(rawtaxn:[Int8]) ->RawTransaction {
        self.rawTransaction=rawtaxn
        return self;
    }

    public func execute( callback: @escaping (_:Response<PostTransactionsResponse>) ->Void){
        print(getRequestString())
        let headers:HTTPHeaders=[client.apiKey:client.token,"Content-type":"application/x-binary"]
        var request=AF.request(getRequestString(),method: .post, parameters: nil, encoding: ByteEncoding(data:Data(CustomEncoder.convertToUInt8Array(input: self.rawTransaction!))), headers: headers,requestModifier: { $0.timeoutInterval = 120 })
  print("Afetre request")
        request.validate()
        var customResponse:Response<PostTransactionsResponse>=Response()
             
  request.responseDecodable(of: PostTransactionsResponse.self){  (response) in
    if(response.error != nil){
        customResponse.setIsSuccessful(value:false)
        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
        customResponse.setErrorDescription(errorDescription:errorDescription!)
        callback(customResponse)
        return
    }
    
    customResponse.setIsSuccessful(value:true)
                    let data=response.value
                    var postTransactionResponse:PostTransactionsResponse=data!
                    customResponse.setData(data:postTransactionResponse)
                    callback(customResponse)

    }
    }

    internal func getRequestString()->String {
        var component=client.connectString()
        component.path = component.path+"/v2/transactions/"
        return component.url!.absoluteString;
        
    }
}
