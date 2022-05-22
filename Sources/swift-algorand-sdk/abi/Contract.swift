//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 10/05/2022.
//

import Foundation

@available(macOS 10.13, *)
public struct Contract{
    
    public var name: String
    public var desc: String
    public var network: [String: NetworkInfo]
    public var methods: [Method];
    
    
    init(name: String, desc: String, methods: [Method], network: [String: NetworkInfo]) {
        self.name = name;
        self.methods = methods
        self.desc = desc
        self.network = network
    }

    public struct NetworkInfo {
        public var appId: Int64
        init(appId: Int64) {
            self.appId = appId;
        }
        
    }
}
