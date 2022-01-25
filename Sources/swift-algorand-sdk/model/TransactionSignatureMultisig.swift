//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/2/21.
//

import Foundation
public struct TransactionSignatureMultisig: Codable, Equatable {
 
    public  var subsignature: [TransactionSignatureMultisigSubsignature]?
    public var threshold: Int64?
    public var version: Int64?
}
