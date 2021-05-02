//
//  File 2.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation

public class Application :Codable{
    
    

   public var createdAtRound:[Int64]?;

    public var deleted:Bool?;

    var deletedAtRound:Int64?;

    
    public var id:Int64?;
    public var  params:ApplicationParams?
    enum CodingKeys:String,CodingKey{
        case createdAtRound = "created-at-round"
        case deleted = "deleted"
        case deletedAtRound = "deleted-at-round"
        case id = "id"
        case params = "params"
    }
}

