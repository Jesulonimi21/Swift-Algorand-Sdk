//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 14/05/2022.
//

import Foundation
public protocol ABIType{
    static var ABI_DYNAMIC_HEAD_BYTE_LEN: UInt64{get}
    static var staticArrayPattern:String{get}
    static var ufixedPattern:String{get}
    func isDynamic() -> Bool
    
    func byteLen() throws -> UInt64
    
    
}

private class Segment {
    public var L, R: Int

    init(left: Int, right: Int) {
        self.L = left;
        self.R = right;
    }
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
    public  static var ufixedPattern: String{
         return "^ufixed(?<size>[1-9][\\d]*)x(?<precision>[1-9][\\d]*)$"
     }

    
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
        }else if(str.hasPrefix("uint")){
            let start = str.index(str.startIndex, offsetBy: 4)
            let end = str.endIndex;
            let range = start..<end
            var size: Int64 = Int64(String(str[range]))!;
            return try TypeUInt(size: size);
        }else if(str == "byte"){
            return try TypeByte()
        }else if(str.starts(with: "ufixed")){
            let ufixedRegex = try! NSRegularExpression(
                pattern: Self.ufixedPattern,
                options: []
            );
            let ufixedPatternRange = NSRange(
              str.startIndex..<str.endIndex,
                in: str
            );
            
            let matches = ufixedRegex.matches(
                in: str,
                options: [],
                range: ufixedPatternRange
            );
            guard let match = matches.first else {
                // Handle exception
                throw NSError(domain: "", code: 0, userInfo: nil)
            }
            var captures: [String: String] = [:]
            for name in ["size", "group"] {
                let matchRange = match.range(withName: name)
                
                // Extract the substring matching the named capture group
                if let substringRange = Range(matchRange, in: str) {
                    let capture = String(str[substringRange])
                    captures[name] = capture
                }
            }
            var size = UInt64(captures["size"] ?? "");
            var precision = UInt64(captures["precision"] ?? "");
            return try TypeUFixed(bitSize: size!, precision: precision!)
        }else if(str == "bool"){
            return TypeBool()
        }else if(str == "string"){
            return TypeString()
        }else if(str.count >= 2 && str.hasSuffix(")") && str[str.startIndex]  == "("){
            var tupleContent = try parseTupleContent(str: str);
            var tupleTypes:[ABIType] = Array();
            for i in 0..<tupleContent.count{
                tupleTypes.append(try self.valueOf(str: tupleContent[i]))
            }
            return TypeTuple(childTypes: tupleTypes)
        }
        throw  Errors.illegalArgumentError("Cannot infer type from the string: \(str)");
    }

    
    public static func parseTupleContent(str: String) throws -> [String]{
        if (str.count == 0){
            return [];
        }
        if(str[str.startIndex] == "," || str[str.endIndex] == ","){
            throw Errors.illegalArgumentError("parsing error: tuple content should not start with comma");
        }
        if (str.contains(",,")){
            throw Errors.illegalArgumentError("parsing error: tuple content should not have consecutive commas");
        }
        var parentStack: [Int] = Array();
        var parentSegments: [Segment] = Array();
        
        for i  in  0..<str.count{
            if(str[i] == "("){
                parentStack.append(i)
            }else if(str[i] == ")"){
                if(parentStack.count == 0){
                    throw Errors.illegalArgumentError("parsing error: tuple parentheses are not balanced: \(str)")
                }
                var leftParentIndex = parentStack.popLast()!;
                if(parentStack.count == 0){
                    parentSegments.append(Segment(left: leftParentIndex, right: i))
                }
            }
        }
            if(parentStack.count != 0 ){
                throw Errors.illegalArgumentError("parsing error: tuple parentheses are not balanced: \(str)")
            }
            var strCopied: String = "";
            for i in stride(from: parentSegments.count, through: 0, by: -1) {
                let firstStart = str.startIndex
                let firstEnd = str.index(str.startIndex, offsetBy: parentSegments[i].L)
                let firstRange = firstStart..<firstEnd
                
                let secondStart = str.index(str.startIndex, offsetBy: parentSegments[i].R)
                let secondEnd = str.index(str.startIndex, offsetBy: 1);
                let secondRange = secondStart..<secondEnd;
                
                strCopied = String(str[firstRange]) + String(str[secondRange])
            }
        var tupleSeg : [String] = strCopied.components(separatedBy: ",");
                var parentSegCount = 0;
                for i in 0..<tupleSeg.count{
                    let start = str.index(str.startIndex, offsetBy: parentSegments[parentSegCount].L);
                    let end = str.index(str.startIndex, offsetBy: parentSegments[parentSegCount].R + 1);
                    let range = start..<end
                    tupleSeg[i] = String(str[range]);
                
            }
        return tupleSeg;
        
    }
    
    

    public static func findBoolLR(typeArray: [ABIType], var index: Int, var delta: Int) -> Int{
        var until = 0;
        while(true){
            var currentIndex = index + delta * Int(until);
            if((typeArray[currentIndex] as? TypeBool) != nil){
                if(currentIndex != typeArray.count-1 && delta > 0){
                    until = until + 1;
                }else if(currentIndex != 0 && delta < 0){
                    until = until + 1;
                }else{
                    break;
                }
            }else{
                until = until - 1;
                break;
            }
        }
        return until;
    }
}
