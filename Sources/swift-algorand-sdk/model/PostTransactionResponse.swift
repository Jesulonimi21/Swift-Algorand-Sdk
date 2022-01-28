//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/10/21.
//

import Foundation
public struct PostTransactionsResponse: Codable, Equatable {
    
    public var txId: String
    
    public init(_ txId: String) {
        self.txId = txId
    }
    
}
