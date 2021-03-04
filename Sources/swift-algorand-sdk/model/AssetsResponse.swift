//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public class  AssetsResponse:Codable{
    public var asset:[AssetData]?;
    public var currentRound:Int64;
    public var nextToken:String?
    
    enum CodingKeys:String,CodingKey{
        case asset="assets"
        case currentRound="current-round"
        case nextToken="next-token"
    }
}
