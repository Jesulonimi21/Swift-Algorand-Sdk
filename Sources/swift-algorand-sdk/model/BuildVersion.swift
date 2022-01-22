//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/3/21.
//

import Foundation

public struct BuildVersion:Codable, Equatable {
    public var branch:String?
    public var build_number:Int64?
    public var channel:String?
    public var commit_hash:String?
    public var major:Int64?
    public var minor:Int64?
}

