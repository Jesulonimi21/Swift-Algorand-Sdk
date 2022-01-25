//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public struct  AssetResponse:Codable, Equatable {
    public var asset:AssetData?;
    public var currentRound:Int64;

    /**
     * Round during which this asset was created.
     */

    public var createdAtRound:Int64?

    /**
     * Whether or not this asset is currently deleted.
     */

    public var deleted:Bool?

    /**
     * Round during which this asset was destroyed.
     */

    public var destroyedAtRound:Int64?

    enum CodingKeys:String,CodingKey{
        case asset="asset"
        case currentRound="current-round"
        case destroyedAtRound = "destroyed-at-round"
        case createdAtRound = "created-at-round"
        case deleted = "deleted"
    }
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
}

