//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/20/21.
//

import Foundation
public struct EvalDeltaKeyValue: Codable, Equatable {

    var key: String?
    var value: EvalDelta?

    enum CodingKeys: String, CodingKey {
        case key="key"
        case value="value"
    }
    init() {}
}
