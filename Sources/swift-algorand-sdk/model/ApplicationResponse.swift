//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public struct ApplicationResponse : Codable, Equatable {
    public var application: Application?
    public var currentRound: Int64?

    
    enum CodingKeys:String,CodingKey{
        case application = "application"
        case currentRound = "current-round"
    }
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try? jsonencoder.encode(self)
        var classString=String(data: classData ?? Data(), encoding: .utf8)
       return classString
    }
}
