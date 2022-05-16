//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 14/05/2022.
//

import Foundation
public protocol ABIType{
    static var ABI_DYNAMIC_HEAD_BYTE_LEN: UInt64{get}
    static  var staticArrayPattern:String{get}
    func isDynamic() -> Bool
    
    func byteLen() throws -> UInt64
    
    
}

extension ABIType{
   public static var ABI_DYNAMIC_HEAD_BYTE_LEN: UInt64 {
        set{
            ABI_DYNAMIC_HEAD_BYTE_LEN = 2
        }
        get{
            return 2
        }
    }
   public  static var staticArrayPattern: String{
        return "^(?<elemT>[a-z\\d\\[\\](),]+)\\[(?<len>[1-9][\\d]*)]$"
    }
//     var staticArrayPattern = "^(?<elemT>[a-z\\d\\[\\](),]+)\\[(?<len>[1-9][\\d]*)]$"
//     var ufixedPattern = "^ufixed(?<size>[1-9][\\d]*)x(?<precision>[1-9][\\d]*)$"
    
    
    @available(macOS 10.13, *)
    static func valueOf(str: String) throws -> ABIType {
    str.startIndex
        if(str.hasSuffix("[]")){
            let start = str.startIndex
            let end = str.index(str.endIndex, offsetBy: -2)
            let range = start..<end
            var elemType: ABIType = try Self.valueOf(str: String(str[range]))
            return try  TypeArrayDynamic(elemType: elemType)
        }else if(str.hasSuffix("]")){
            let staticArrayPatternRange = NSRange(
              str.startIndex..<str.endIndex,
                in: str
            )
            
            let staticArrayRegex = try! NSRegularExpression(
                pattern: Self.staticArrayPattern,
                options: []
            )
            
            let matches = staticArrayRegex.matches(
                in: str,
                options: [],
                range: staticArrayPatternRange
            )
            
            guard let match = matches.first else {
                // Handle exception
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            var captures: [String: String] = [:]

            // For each matched range, extract the named capture group
            for name in ["elemT", "len"] {
                let matchRange = match.range(withName: name)
                
                // Extract the substring matching the named capture group
                if let substringRange = Range(matchRange, in: str) {
                    let capture = String(str[substringRange])
                    captures[name] = capture
                }
            }
            var elemT = try Self.valueOf(str: captures["elemT"] ?? "")
            var length = UInt64(captures["len"] ?? "") ?? 0
            
            
            return try TypeArrayStatic(elemType: elemT, length:length )
        }
        throw  Errors.illegalArgumentError("Cannot infer type from the string: \(str)");
    }
    
}
