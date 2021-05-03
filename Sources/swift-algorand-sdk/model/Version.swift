//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
public class Version:Codable{

    public var build:BuildVersion;

    public var genesis_hash_b64:[Int8]?


    public var genesis_id:String?

    public var versions: [String]?
    
    enum CodingKeys:String,CodingKey{
        case versions = "versions"
        case genesis_id = "genesis_id"
        case genesis_hash_b64 = "genesis_hash_b64"
        case build = "build"
    }
    
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.versions = try container.decode([String].self, forKey: .versions)
        self.genesis_id = try container.decode(String.self,forKey: .genesis_id)
        
        var genesisHashB64 = try? container.decode(String.self,forKey: .genesis_hash_b64)
        
        if let gHash64 = genesisHashB64{
            self.genesis_hash_b64 = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: gHash64)) 
        }
   
        
        self.build = try container.decode(BuildVersion.self,forKey: .build)
    }
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }

}
