//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/8/21.
//

import Foundation

public struct TransactionParametersResponse:Codable, Equatable {

    
    public  var consensusVersion:String?;
    public  var fee:Int64?;
    public var genesisId:String?;
    public    var lastRound:Int64?;
    public   var minFee:Int64?;

    private var gHash64:String?
    public var genesisHash:[Int8]? {
        get {
            if let gHash64 = gHash64 {
                return CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: gHash64))
            }
            return nil
        }
    }
    
    enum CodingKeys:String,CodingKey{
        case consensusVersion="consensus-version"
        case fee="fee"
        case genesisId="genesis-id"
        case lastRound="last-round"
        case minFee="min-fee"
        case gHash64="genesis-hash"
    }
    
    init() {
    }
    public  init(fee:Int64,genesisHash:[Int8],genesisId:String,lastRound:Int64){
        //probably not the best solution with continuous conversion from/to base64, but guarantees compatibility with codable.
        self.gHash64 = CustomEncoder.encodeToBase64(genesisHash)
        self.fee=fee
        self.lastRound=lastRound
        self.genesisId=genesisId
    }
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        try  self.fee=container.decode(Int64.self, forKey: .fee)
//        try  self.genesisId=container.decode(String.self, forKey: .genesisId)
//        try  self.lastRound=container.decode(Int64.self, forKey: .lastRound)
//        try self.minFee=container.decode(Int64.self, forKey: .minFee)
//        try  self.fee=container.decode(Int64.self, forKey: .fee)
//        try  self.consensusVersion=container.decode(String.self, forKey: .consensusVersion)
//        let base64String = try container.decode(String.self, forKey: .genesisHash)
//        self.genesisHash=CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: base64String))
//
//    }


  
}
