//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public struct AssetData: Codable, Equatable {

    public var index:Int64?;

    public var params:AssetParamsData?;

    enum CodingKeys:String,CodingKey{
        case index="index"
        case params="params"
    }
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
    
}
