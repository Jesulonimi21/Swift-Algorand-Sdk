//
//  File.swift
//  
//
//  Created by Stefano Mondino on 08/05/22.
//

import Foundation

/// A convenience struct to map binary data (base64 strings) into `[Int8]` arrays
 struct BinaryData: Codable, Equatable {
    var value: [Int8]
    init?(_ value: [Int8]?) {
        guard let value = value else {
            return nil
        }
        self.value = value
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode([Int8].self) {
            self.value = value
        } else {
            let string = try container.decode(String.self)
            self.value = CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: string))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(CustomEncoder.encodeToBase64(value))
    }
}
