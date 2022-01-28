//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation

enum OnCompletionData: String {
    case NOOP="noop"
    case OPTIN="optin"
    case CLOSEOUT="closeout"
    case CLEAR="clear"
    case UPDATE="update"
    case DELETE="delete"
}

 extension OnCompletionData: Codable {
    enum Key: CodingKey {
        case rawValue
    }
    
    public init(from decoder: Decoder) throws {
//        var container = try! decoder.container(keyedBy: Key.self)
        var container = try! decoder.singleValueContainer()
        var rawValue = try! container.decode(String.self)
        switch rawValue {
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

public enum AddressRole {
    case SENDER
    case RECEIVER
    case FREEZETARGET
}

extension AddressRole: Decodable {
    
    enum Key: CodingKey {
        case rawValue
    }
    public init(from decoder: Decoder) throws {
        var container = try! decoder.container(keyedBy: Key.self)
        var rawValue = try! container.decode(String.self, forKey: .rawValue)
        
        switch rawValue {
        case "sender":self = .SENDER
        case "receiver":self = .RECEIVER
        case "freeze-target":self = .FREEZETARGET
        
        default:
          self =  .SENDER
        }
    }
}

public enum SigType {
    case SIG
    case MSIG
    case LSIG
}

extension SigType: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = try! encoder.singleValueContainer()
        switch self {
        case .SIG: try! container.encode("sig")
        case .MSIG:try! container.encode("msig")
        case .LSIG:try! container.encode("LSIG")
        default: try! container.encode("sig")
        }
    }
    
    enum Key: CodingKey {
        case rawValue
    }
    public init(from decoder: Decoder) throws {
        var container = try! decoder.singleValueContainer()
        var rawValue = try! container.decode(String.self)
        
        switch rawValue {
        case "sig" : self = .SIG
        case "msig" : self = .MSIG
        case "lsig" : self = .LSIG
            
        default : self = .SIG
        }
    }
    
}

public enum TxType: String {
    case PAY="pay"
    case KEYREG="keyreg"
    case ACFG="acfg"
    case AXFER="axfer"
    case AFRZ="afrz"
    case APPL="appl"
}

extension TxType: Codable {
     
    enum Key: String, CodingKey {
        case rawValue
    }
    
    public init(from decoder: Decoder) throws {
//        var container = try! decoder.container(keyedBy:Key.self )
        var container = try! decoder.singleValueContainer()
        var rawValue = try! container.decode(String.self)
        
        switch rawValue {
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
