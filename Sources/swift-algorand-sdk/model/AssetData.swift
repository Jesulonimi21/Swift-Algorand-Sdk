//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public class AssetData:Codable{
 
    public var index:Int64?;

    public var params:AssetParamsData?;

    enum CodingKeys:String,CodingKey{
        case index="index"
        case params="params"
    }
   
}
