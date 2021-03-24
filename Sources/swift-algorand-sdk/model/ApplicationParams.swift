//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public class ApplicationParams:Codable{
    public var approvalProgram:[Int8]?
    public var clearStateProgram:[Int8]?
    public var creator:String?
  
    public var globalState:[TealKeyValue]?
  
    public var globalStateSchema:ApplicationStateSchema?;
  
    public var localStateSchema:ApplicationStateSchema?;

    
    enum CodingKeys:String,CodingKey{
    case globalState="global-state"
   
     case globalStateSchema="global-state-schema"

     case localStateSchema="local-state-schema"
    case creator="creator"
    case clearStateProgram="clear-state-program"
     case approvalProgram="approval-program"

    }
    
    
    
    
    public required init(from decoder: Decoder) throws {
        var container = try! decoder.container(keyedBy: CodingKeys.self)
        self.creator = try! container.decode(String.self, forKey: .creator)
        self.localStateSchema = try! container.decode(ApplicationStateSchema.self, forKey: .localStateSchema)
        self.globalStateSchema = try! container.decode(ApplicationStateSchema.self, forKey: .globalStateSchema)
        self.globalState = try? container.decode([TealKeyValue].self, forKey: .globalState)
        
        var approvalProgramString = try? container.decode(String.self, forKey: .approvalProgram)
        if let approvalProgramstr=approvalProgramString{
            self.approvalProgram = CustomEncoder.convertToInt8Array(input:  CustomEncoder.convertBase64ToByteArray(data1: approvalProgramstr))
        }
    

        var clearStateProgramString = try? container.decode(String.self, forKey: .clearStateProgram)
        if let clearStateProgramStr = clearStateProgramString{
            self.clearStateProgram = CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: clearStateProgramStr))
        }
       
    }
}
