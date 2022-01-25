//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/3/21.
//

import Foundation
public struct ApplicationLocalState: Codable, Equatable {
    public var id: Int64?

    public var keyValue: [TealKeyValue]?

    public var schema: ApplicationStateSchema?
    
    enum CodingKeys: String, CodingKey {
        case schema="schema"
        case keyValue="key-value"
        case id="id"
    }

}
