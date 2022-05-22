//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 22/05/2022.
//

import Foundation
@available(macOS 10.13, *)
public struct Interface{
    public var name: String
    public var desc: String
    public var methods: [Method]
    
    
    init(name: String, desc: String, methods: [Method]) {
        self.name = name
        self.desc = desc
        self.methods = methods
    }
}
