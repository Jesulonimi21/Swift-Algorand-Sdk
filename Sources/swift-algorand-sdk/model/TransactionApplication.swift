//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation
public class TransactionApplication:Codable{
    public var accounts:[String]?
    public var applicationArgs:[String]?
    public var applicationId:Int64?
    public var approvalProgram:String?
    public var clearStateProgram:[String]?
    public var foreignApps:[Int64]?
    public var foreignAssets:[Int64]?
    public var globalStateSchema:StateSchema?
    public var localStateSchema:StateSchema?
    internal var onCompletionData: OnCompletionData?

    
    enum CodingKeys:String,CodingKey{
        case accounts="accounts"
        case applicationArgs="application-args"
        case approvalProgram="approval-program"
        case clearStateProgram="clear-state-program"
        case applicationId="application-id"
        case foreignApps="foreign-apps"
        case foreignAssets="foreign-assets"
        case globalStateSchema="global-state-schema"
        case localStateSchema="local-state-schema"
        case onCompletionData="on-completion"
    }
    
    
//    public required init(from decoder: Decoder) throws {
//        var container = decoder.container(keyedBy: CodingKeys.self)
//
//    }
}
