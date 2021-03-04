//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation

public class AssetParamsData : Codable{
         public var clawback:String?;
           public var creator:String?;
            public var decimals:Int64?;
            public var defaultFrozen:Bool?;
          public var freeze:String?;
           public var manager:String?;
            public var metadataHash:[Int8]?;
        public var name:String?;
           public var reserve:String?;
         public var total:Int64?;
             public var unitName:String?;
       public var url:String?;
    
    enum CodingKeys:String,CodingKey{
       
           case clawback="clawback"
           case creator="creator";
           case decimals="decimals";
           case defaultFrozen="default-frozen";
           case freeze="freeze";
           case manager="manager";
          case name="name"
          case reserve="reserve";
           case total="total";
           case unitName="unit-name";
          case url="url";
    }
}
