//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/2/21.
//

import Foundation


public class TealDryRun: Request {
    public typealias ResponseType = DryrunResponse
    public let client: HTTPClient
    private(set) public var parameters: RequestParameters

    init(client: AlgodClient, request: DryrunRequest) {
        self.client = client
        parameters = .init(path: "/v2/teal/dryrun",
                           headers: ["Content-type": "application/x-binary"],
                           method: .post,
                           encoding: ByteEncoding(data: Data(CustomEncoder.encodeToMsgPack(request))))
    }
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, request: DryrunRequest)` instead")
    public init(client: AlgodClient) {
        self.client = client
        self.parameters = .init(path: "")
    }
    
    @available(*, deprecated, message: "Use `init(client: AlgodClient, request: DryrunRequest)` instead")
    public func request(request: DryrunRequest) -> TealDryRun {
        parameters = .init(path: "/v2/teal/dryrun", headers: ["Content-type": "application/x-binary"],
                           method: .post,
                           encoding: ByteEncoding(data: Data(CustomEncoder.encodeToMsgPack(request))))
        return self
    }
}
// public class TealDryRun{
//    var client:AlgodClient
//    var request:DryrunRequest?
//    init(client:AlgodClient) {
//        self.client=client
//    }
//
//    public func request(request:DryrunRequest) ->TealDryRun {
//        self.request=request
//        return self;
//    }
//
//    public func execute( callback: @escaping (_:Response<DryrunResponse>) ->Void){
////        print(getRequestString())
//        var data:[UInt8] = CustomEncoder.encodeToMsgPack(request!)
//        print(data)
//        let headers:HTTPHeaders=[client.apiKey:client.token,"Content-type":"application/x-binary"]
//        var request=AF.request(getRequestString(),method: .post, parameters: nil, encoding: ByteEncoding(data:Data(data)), headers: headers,requestModifier: { $0.timeoutInterval = 120 })
//
////        request.responseJSON(){response in
////            debugPrint(response.value)
////            print("response json")
////        }
//        request.validate()
//        var customResponse:Response<DryrunResponse>=Response()
//
//  request.responseDecodable(of: DryrunResponse.self){  (response) in
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
//        }
//                return
//    }
//
//    customResponse.setIsSuccessful(value:true)
//                    let data=response.value
//                    var dryrunResponse:DryrunResponse=data!
//                    customResponse.setData(data:dryrunResponse)
//                    callback(customResponse)
//
//    }
//    }
//
//    internal func getRequestString()->String {
//        var component=client.connectString()
//        component.path = component.path+"/v2/teal/dryrun"
//        return component.url!.absoluteString;
//
//    }
// }
