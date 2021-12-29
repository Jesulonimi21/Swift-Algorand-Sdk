//
//  File.swift
//
//
//  Created by Jesulonimi on 5/3/21.
//

import Alamofire
import Foundation
public class GetAssetById {
    var client: AlgodClient

    var assetId: Int64
    init(client: AlgodClient, assetId: Int64) {
        self.client = client
        self.assetId = assetId
    }

    public func execute(callback: @escaping (_: Response<AssetData>) -> Void) {
//        print(getRequestString(parameter: self.assetId))
        let headers: HTTPHeaders = [client.apiKey: client.token]
        var request = AF.request(getRequestString(parameter: assetId),
                                 method: .get,
                                 parameters: nil,
                                 headers: headers,
                                 requestModifier: { $0.timeoutInterval = 120 })
        request.validate()
        var customResponse: Response<AssetData> = Response()

        request.responseDecodable(of: AssetData.self) { response in

            if response.error != nil {
                customResponse.setIsSuccessful(value: false)
                var errorDescription = String(data: response.data ?? Data((response.error?.errorDescription ?? "").utf8), encoding: .utf8)
                customResponse.setErrorDescription(errorDescription: errorDescription ?? "")
                callback(customResponse)
                if response.data != nil {
                    if let message = String(data: response.data ?? Data(), encoding: .utf8),
                       let errorDic = (try? JSONSerialization.jsonObject(with: message.data, options: [])) as? [String: Any]
                    {
                        // This force unwrap was causing an error when response is a proper 200 from server, but local Swift Decoding is failing.
                        customResponse.errorMessage = errorDic["message"] as? String ?? "Error not available"
                    } else {
                        customResponse.errorMessage = "Error not available"
                    }
                }
                return
            }

            guard let data = response.value else { return }
            var assetResponse: AssetData = data
            customResponse.setData(data: assetResponse)
            customResponse.setIsSuccessful(value: true)
            callback(customResponse)
        }
    }

    internal func getRequestString(parameter _: Int64) -> String {
        var component = client.connectString()
        component.path = component.path + "/v2/assets/\(assetId)"
        return component.url?.absoluteString ?? ""
    }
}
