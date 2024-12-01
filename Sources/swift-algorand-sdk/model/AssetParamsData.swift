//
//  File.swift
//
//
//  Created by Jesulonimi on 3/1/21.
//

import Foundation

public struct AssetParamsData: Codable, Equatable {
    public var clawback: String?
    public var creator: String?
    public var decimals: Int64?
    public var defaultFrozen: Bool?
    public var freeze: String?
    public var manager: String?
    private var metadataHashString: BinaryData?
    public var metadataHash: [Int8]? {
        get { metadataHashString?.value }
        set { metadataHashString = .init(newValue) }
    }
    public var name: String?
    public var reserve: String?
    // Possibily breaking change if anyone have based their local implementations around Int64. However, this is leading some JSON decoding to failures due to really big amounts (overflowing Int64)
    public var total: Double?
    public var unitName: String?
    public var url: String?

    enum CodingKeys: String, CodingKey {
        case clawback
        case creator
        case decimals
        case metadataHashString = "metadata-hash"
        case defaultFrozen = "default-frozen"
        case freeze
        case manager
        case name
        case reserve
        case total
        case unitName = "unit-name"
        case url
    }
}
