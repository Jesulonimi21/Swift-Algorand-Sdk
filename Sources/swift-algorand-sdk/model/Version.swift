//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation
public struct Version:Codable, Equatable {

    public var build:BuildVersion

    private var gHash64:String?

    public var genesis_hash_b64:[Int8]? {
        guard let gHash64 = gHash64 else { return nil }
        return CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: gHash64))
    }

    public var genesis_id:String?

    public var versions: [String]?
    
    enum CodingKeys:String,CodingKey{
        case versions = "versions"
        case genesis_id = "genesis_id"
        case gHash64 = "genesis_hash_b64"
        case build = "build"
    }
    
    internal init(build: BuildVersion,
                  genesis_hash_string: String? = nil,
                  genesis_id: String? = nil,
                  versions: [String]? = nil) {
        self.build = build
        self.gHash64 = genesis_hash_string
        self.genesis_id = genesis_id
        self.versions = versions
    }
    

    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.versions = try container.decode([String].self, forKey: .versions)
//        self.genesis_id = try container.decode(String.self,forKey: .genesis_id)
//
//        var genesisHashB64 = try? container.decode(String.self,forKey: .genesis_hash_b64)
//
//        if let gHash64 = genesisHashB64{
//            self.genesis_hash_b64 = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: gHash64))
//        }
//
//
//        self.build = try container.decode(BuildVersion.self,forKey: .build)
//    }
    
    public func toJson()->String?{
        var jsonencoder=JSONEncoder()
        var classData=try? jsonencoder.encode(self)
        var classString=String(data: classData ?? Data(), encoding: .utf8)
       return classString
    }

}
