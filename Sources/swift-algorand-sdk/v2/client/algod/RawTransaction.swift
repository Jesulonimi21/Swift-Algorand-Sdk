//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/10/21.
//

import Foundation
import Alamofire

public class RawTransaction: Request {
    public typealias ResponseType = PostTransactionsResponse
    public let client: HTTPClient
    private(set) public var parameters: RequestParameters
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, rawtxn: [Int8])` instead")
    init(client: AlgodClient) {
        self.client = client
        parameters = .init(path: "")
    }
    
    init(client: AlgodClient, rawtxn: [Int8]) {
        self.client = client
        parameters = .init(path: "/v2/transactions/",
                           headers: ["Content-type":"application/x-binary"],
                            method: .post,
                            encoding: ByteEncoding(data: Data(CustomEncoder.convertToUInt8Array(input: rawtxn))))
    }
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, rawtxn: [Int8])` instead")
    func rawtxn(rawtaxn:[Int8]) ->RawTransaction {
        self.parameters = .init(path: "/v2/transactions/", headers: ["Content-type":"application/x-binary"],
                                method: .post,
                                encoding: ByteEncoding(data: Data(CustomEncoder.convertToUInt8Array(input: rawtaxn))))
        return self;
    }
    
}

//public class RawTransaction{
//    var client:AlgodClient
//    var rawTransaction:[Int8]?
//    init(client:AlgodClient) {
//        self.client=client
//    }
//
//    public func rawtxn(rawtaxn:[Int8]) ->RawTransaction {
//        self.rawTransaction=rawtaxn
//        return self;
//    }
//
//    public func execute( callback: @escaping (_:Response<PostTransactionsResponse>) ->Void){
////        print(getRequestString())
//        let headers:HTTPHeaders=[client.apiKey:client.token,"Content-type":"application/x-binary"]
//        var request=AF.request(getRequestString(),method: .post, parameters: nil, encoding: ByteEncoding(data:Data(CustomEncoder.convertToUInt8Array(input: self.rawTransaction!))), headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//
////        request.responseJSON(){response in
////            debugPrint(response.value)
////            print("response json")
////        }
//        request.validate()
//        var customResponse:Response<PostTransactionsResponse>=Response()
//
//  request.responseDecodable(of: PostTransactionsResponse.self){  (response) in
//    if(response.error != nil){
//        customResponse.setIsSuccessful(value:false)
//        var errorDescription=String(data:response.data ?? Data(response.error!.errorDescription!.utf8),encoding: .utf8)
//        customResponse.setErrorDescription(errorDescription:errorDescription!)
//        callback(customResponse)
//
//        if(response.data != nil){
//            if let message = String(data: response.data!,encoding: .utf8){
//                var errorDic = try! JSONSerialization.jsonObject(with: message.data, options: []) as? [String: Any]
//                customResponse.errorMessage = errorDic!["message"] as! String
//
//            }
//
//        }
//                return
//    }
//
//    customResponse.setIsSuccessful(value:true)
//                    let data=response.value
//                    var postTransactionResponse:PostTransactionsResponse=data!
//                    customResponse.setData(data:postTransactionResponse)
//                    callback(customResponse)
//
//    }
//    }
//
//    internal func getRequestString()->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/transactions/"
//        return component.url!.absoluteString;
//
//    }
//}
