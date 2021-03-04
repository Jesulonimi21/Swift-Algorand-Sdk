//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation

enum OnCompletionData{
    case NOOP
    case OPTIN
    case CLOSEOUT
    case CLEAR
    case UPDATE
    case DELETE
}

 extension OnCompletionData: Decodable {
    enum Key:CodingKey{
        case rawValue
    }
    
    public init(from decoder: Decoder) throws {
        var container = try! decoder.container(keyedBy: Key.self)
        var rawValue = try! container.decode(String.self, forKey: .rawValue)
        switch rawValue{
        case "noop": self = .NOOP
        case "optin":self = .OPTIN
        case "closeout":self = .CLOSEOUT
        case "clear":self = .CLEAR
        case "update":self = .UPDATE
        case "delete":self = .DELETE
        default:
            self = .DELETE
        }
    }
}



public enum AddressRole{
    case SENDER
    case RECEIVER
    case FREEZETARGET
}

extension AddressRole : Decodable{
    
    enum Key:CodingKey{
        case rawValue
    }
    public init(from decoder: Decoder) throws {
        var container = try! decoder.container(keyedBy: Key.self)
        var rawValue = try! container.decode(String.self, forKey: .rawValue)
        
        switch rawValue{
        case "sender":self = .SENDER
        case "receiver":self = .RECEIVER
        case "freeze-target":self = .FREEZETARGET
        
        default:
          self =  .SENDER
        }
    }
}


public enum SigType{
    case SIG
    case MSIG
    case LSIG
}

extension SigType : Decodable{
    
    enum Key:CodingKey{
        case rawValue
    }
    public init(from decoder: Decoder) throws {
        var container = try! decoder.singleValueContainer()
        var rawValue = try! container.decode(String.self)
        
        switch rawValue{
        case "sig" : self = .SIG
        case "msig" : self = .MSIG
        case "lsig" : self = .LSIG
            
        default : self = .SIG
        }
    }
}




public enum TxType:String{
    case PAY="pay"
    case KEYREG="keyreg"
    case ACFG="acfg"
    case AXFER="axfer"
    case AFRZ="afrz"
    case APPL="appl"
}

extension TxType : Decodable{
     
    enum Key:String,CodingKey{
        case rawValue
    }
    
    public init(from decoder: Decoder) throws {
//        var container = try! decoder.container(keyedBy:Key.self )
        var container = try! decoder.singleValueContainer()
        var rawValue = try! container.decode(String.self)
        
        switch rawValue{
        case "pay" : self = .PAY
        case "keyreg" : self = .KEYREG
        case "acfg" : self = .ACFG
        case "axfer" : self = .AXFER
        case "afrz" : self = .AFRZ
        case "appl" : self = .APPL
        default : self = .APPL
        }
    }
}
