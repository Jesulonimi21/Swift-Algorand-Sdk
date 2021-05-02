//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/1/21.
//

import Foundation
public class DryrunTxnResult :Codable {

  
    public var  appCallMessages:[String]?


    public var appCallTrace:[DryrunState]?

    /**
     * Disassembled program line by line.
     */
 
    public var disassembly:[String]?

    /**
     * Application state delta.
     */

    public var globalDelta:[EvalDeltaKeyValue]?


    public var localDeltas:[AccountStateDelta]?


    public var  logicSigMessages:[String]?


    public var  logicSigTrace: [DryrunState]?

    enum CodingKeys:String,CodingKey{
        case appCallMessages = "app-call-messages"
        case disassembly = "disassembly"
        case globalDelta = "global-delta"
        case localDeltas = "local-deltas"
        case logicSigMessages = "logic-sig-messages"
        case logicSigTrace = "logic-sig-trace"
        case appCallTrace = "app-call-trace"
    }

}
