//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation

public class NodeStatusResponse : Codable {
    
   
    public    var catchpoint:String?;

    public   var catchpointAcquiredBlocks:Int64?

    public  var catchpointProcessedAccounts:Int64?

    public   var catchpointTotalAccounts:Int64?;
  
    public  var catchpointTotalBlocks:Int64?;
   
    public  var catchupTime:Int64?;
 
    public    var lastCatchpoint:String?;
  
    public  var  lastRound:Int64?;
  
    public  var lastVersion:String?;
   
    public    var nextVersion:String?;
   
    public    var nextVersionRound:Int64?;
  
    public   var nextVersionSupported:Bool?;

    public    var stoppedAtUnsupportedRound:Bool?;
    
    public   var timeSinceLastRound:Int64?;


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
