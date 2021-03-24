//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public class ApplicationsResponse : Codable{
    public var applications: [Application]?
    public var currentRound: Int64?
    public var nextToken : String?
    
    enum CodingKeys:String,CodingKey{
        case applications = "applications"
        case currentRound = "current-round"
        case nextToken = "next-token"
    }
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
}
