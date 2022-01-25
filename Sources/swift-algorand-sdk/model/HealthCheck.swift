//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/26/21.
//

import Foundation
public struct HealthCheck : Codable, Equatable {
   
   public var data:[String:Bool]?;
  
    public var message:String?;
    
    enum CodingKeys:String,CodingKey {
        case data="data"
        case message="message"
    }
    
    public init(from decoder: Decoder) throws {
        var container=try decoder.container(keyedBy: CodingKeys.self)
        self.message = try? container.decode(String.self, forKey: .message)
        self.data=try? container.decode(Dictionary.self, forKey: .data);
    }
    

   init() {
    }
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try? jsonencoder.encode(self)
        var classString=String(data: classData ?? Data(), encoding: .utf8)
       return classString
    }
    
}
