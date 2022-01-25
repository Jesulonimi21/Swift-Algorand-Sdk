//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public struct  AssetsResponse:Codable, Equatable {
    public var asset:[AssetData]?;
    public var currentRound:Int64;
    public var nextToken:String?
    
    enum CodingKeys:String,CodingKey{
        case asset="assets"
        case currentRound="current-round"
        case nextToken="next-token"
    }
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try? jsonencoder.encode(self)
        var classString=String(data: classData ?? Data(), encoding: .utf8)
       return classString
    }
}
