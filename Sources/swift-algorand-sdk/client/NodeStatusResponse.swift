//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation

public class NodeStatusResponse : Codable {
    
   
    var catchpoint:String?;

    var catchpointAcquiredBlocks:Int64?

    var catchpointProcessedAccounts:Int64?

    var catchpointTotalAccounts:Int64?;
  
    var catchpointTotalBlocks:Int64?;
   
    var catchupTime:Int64?;
 
    var lastCatchpoint:String?;
  
    var  lastRound:Int64?;
  
    var lastVersion:String?;
   
    var nextVersion:String?;
   
    var nextVersionRound:Int64?;
  
    var nextVersionSupported:Bool?;

    var stoppedAtUnsupportedRound:Bool?;
    
    var timeSinceLastRound:Int64?;


    enum CodingKeys:String,CodingKey{
        case catchpoint="catchpoint"
        case catchpointAcquiredBlocks="catchpoint-acquired-blocks"
        case catchpointProcessedAccounts="catchpoint-processed-accounts"
        case catchpointTotalAccounts="catchpoint-total-accounts"
        case catchpointTotalBlocks="catchpoint-total-blocks"
        case catchupTime="catchup-time"
        case lastCatchpoint="last-catchpoint"
        case lastRound="last-round"
        case lastVersion="last-version"
       

        case nextVersion="next-version";
    
        case nextVersionRound="next-version-round";

        case nextVersionSupported="next-version-supported";

        case stoppedAtUnsupportedRound="stopped-at-unsupported-round";
       
        case timeSinceLastRound="time-since-last-round";
        
    }
    
   init() {
    }

   
}
