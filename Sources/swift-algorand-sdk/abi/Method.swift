//
//  File.swift
//  
//
//  Created by Jesulonimi Akingbesote on 10/05/2022.
//

import Foundation
@available(macOS 10.13, *)
public struct Method{
    public static var TxAnyType:String = "Any"
    public static var TxArgTypes: [String] = [
        TxAnyType, Transaction.type.Payment.rawValue,
        Transaction.type.KeyRegistration.rawValue,
        Transaction.type.AssetConfig.rawValue,
        Transaction.type.AssetTransfer.rawValue,
        Transaction.type.AssetFreeze.rawValue,
        Transaction.type.ApplicationCall.rawValue
    ]
    public static var RefTypeAccount:String = "account"
    public static var RefTypeAsset = "asset"
    public static var RefTypeApplication = "application"
    public static var RefArgTypes = [RefTypeAccount, RefTypeAsset, RefTypeApplication]
    public var HASH_ALG = "SHA-512/256"
 
    public var name:String
    public var desc: String
    public var args: [Arg]
    public var returns: Returns
    public var txnCallCount = 1
    
    static func isTxnArgOrForeignArrayArgs(str: String) -> Bool{
        return TxArgTypes.contains(str) || RefArgTypes.contains(str)
    }
    
    init(name: String, desc: String, args: [Arg], return: Returns ) throws {
        self.name = name
        self.desc = desc
        self.args = args
        for i in 0..<args.count{
            if(Method.TxArgTypes.contains(args[i].type)){
                self.txnCallCount = self.txnCallCount + 1;
            }
        }
        self.returns =  try Returns(type: Returns.VoidRetType, desc: nil)
    }
    
    static func methodParse(method: String)throws ->  [String]{
        var parentStack: [Int] = Array();
        for i in 0..<method.count{
            if (method[method.index(method.startIndex, offsetBy: i)] == "("){
                parentStack.append(i)
            }else if(method[method.index(method.startIndex, offsetBy: i)] == ")"){
                if(parentStack.count == 0){
                    break;
                }
                var leftParentIndex = parentStack.popLast()
                if(parentStack.count > 0){
                    continue
                }
                var res: [String] = Array()
                if(leftParentIndex! + 1 == i){
                    res.append("")
                }else{
                    res.append(String(method[method.index(method.startIndex, offsetBy: leftParentIndex!)..<method.index(method.startIndex, offsetBy: leftParentIndex! + 1 + i)]))
                }
                res.append(String(method[method.index(method.startIndex, offsetBy: i)..<method.index(method.startIndex, offsetBy:  1 + i)]))
                return res
            }
        }
        
        throw Errors.illegalArgumentError("method string parentheses unbalanced: \(method)")
    }
    
    
    
    public func getSignature () -> String{
        var argStringList: [String] = Array()
        for i in 0..<args.count {
            argStringList.append(args[i].type)
        }
        return self.name + "(" + argStringList.joined(separator: ",") + ")" + self.returns.type
    }
    
    
    public func getSelector() -> [Int8]{
        var method = self.getSignature();
        var decodedByte=CustomEncoder.decodeByteFromBase64(string: method)
        var computedImage=CustomEncoder.convertToSha256(data: Data(decodedByte))
        var arr:[Int8] = Array()
        for i in 0..<computedImage.count{
            if(i<4){
                arr.append(computedImage[i])
            }
        }
        return arr;
    }
    
    

    

    
    public struct Returns{
        public static var VoidRetType = "void"
        public var type:String
        public var desc:String?
        public var parsedType: ABIType?
        
        @available(macOS 10.13, *)
        init(type:String, desc: String?) throws {
            self.type = type
            self.desc = desc
            self.parsedType = type == "void" ? nil : try TypeAddress.valueOf(str: type)
        }
        
        
        @available(macOS 10.13, *)
        init (returns: Returns)throws{
            try self.init(type: returns.type, desc: returns.desc);
            self.parsedType = returns.parsedType
        }
    }
    
    
   

    
    public struct Arg{
        public var name:String
        public var type:String
        public var desc: String
        public var parsedType: ABIType?
        
        @available(macOS 10.13, *)
        init(name: String, type: String, desc: String) throws {
            self.name = name
            self.type = type
            self.desc = desc
            self.parsedType = Method.isTxnArgOrForeignArrayArgs(str: type) ? nil: try TypeAddress.valueOf(str: type)
        }
        
        @available(macOS 10.13, *)
        init(arg:Arg) throws {
            try self.init(name: arg.name, type: arg.type, desc: arg.desc);
            self.parsedType = arg.parsedType
        }
        
    }
    
    
   

}
