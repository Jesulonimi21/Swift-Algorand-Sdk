//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation

public struct NodeStatusResponse: Codable, Equatable {
   
    public    var catchpoint: String?

    public   var catchpointAcquiredBlocks: Int64?

    public  var catchpointProcessedAccounts: Int64?

    public   var catchpointTotalAccounts: Int64?
  
    public  var catchpointTotalBlocks: Int64?
   
    public  var catchupTime: Int64?
 
    public    var lastCatchpoint: String?
  
    public  var  lastRound: Int64?
  
    public  var lastVersion: String?
   
    public    var nextVersion: String?
   
    public    var nextVersionRound: Int64?
  
    public   var nextVersionSupported: Bool?

    public    var stoppedAtUnsupportedRound: Bool?
    
    public   var timeSinceLastRound: Int64?

    enum CodingKeys: String, CodingKey {
        case catchpoint="catchpoint"
        case catchpointAcquiredBlocks="catchpoint-acquired-blocks"
        case catchpointProcessedAccounts="catchpoint-processed-accounts"
        case catchpointTotalAccounts="catchpoint-total-accounts"
        case catchpointTotalBlocks="catchpoint-total-blocks"
        case catchupTime="catchup-time"
        case lastCatchpoint="last-catchpoint"
        case lastRound="last-round"
        case lastVersion="last-version"

        case nextVersion="next-version"
    
        case nextVersionRound="next-version-round"

        case nextVersionSupported="next-version-supported"

        case stoppedAtUnsupportedRound="stopped-at-unsupported-round"
       
        case timeSinceLastRound="time-since-last-round"
        
    }
    
   init() {}
    
    init(catchpoint: String? = nil,
         catchpointAcquiredBlocks: Int64? = nil,
         catchpointProcessedAccounts: Int64? = nil,
         catchpointTotalAccounts: Int64? = nil,
         catchpointTotalBlocks: Int64? = nil,
         catchupTime: Int64? = nil,
         lastCatchpoint: String? = nil,
         lastRound: Int64? = nil,
         lastVersion: String? = nil,
         nextVersion: String? = nil,
         nextVersionRound: Int64? = nil,
         nextVersionSupported: Bool? = nil,
         stoppedAtUnsupportedRound: Bool? = nil,
         timeSinceLastRound: Int64? = nil) {
        self.catchpoint = catchpoint
        self.catchpointAcquiredBlocks = catchpointAcquiredBlocks
        self.catchpointProcessedAccounts = catchpointProcessedAccounts
        self.catchpointTotalAccounts = catchpointTotalAccounts
        self.catchpointTotalBlocks = catchpointTotalBlocks
        self.catchupTime = catchupTime
        self.lastCatchpoint = lastCatchpoint
        self.lastRound = lastRound
        self.lastVersion = lastVersion
        self.nextVersion = nextVersion
        self.nextVersionRound = nextVersionRound
        self.nextVersionSupported = nextVersionSupported
        self.stoppedAtUnsupportedRound = stoppedAtUnsupportedRound
        self.timeSinceLastRound = timeSinceLastRound
    }
    public func toJson() -> String? {
        var jsonencoder=JSONEncoder()
        var classData=try! jsonencoder.encode(self)
        var classString=String(data: classData, encoding: .utf8)
       return classString
    }
    
}
