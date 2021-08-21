//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/7/21.
//

import Foundation
extension BinaryInteger where Self: FixedWidthInteger {

    /// Safely converts Float to BinaryInteger (Uint8, Uint16, Int8, and so on), truncate remains that do not fit in the instance of BinaryInteger range value.
    /// For instance, if Float value is 300.934, and self is UInt8, it will be 255, or if Float value is -100.2342, self value will be 0
    init(truncateToFit float: Float) {
        switch float {
        case _ where float < Float(Self.min): self.init(Self.min)
        case _ where float > Float(Self.max): self.init(Self.max)
        default: self.init(float)
        }
    }

    /// Safely converts Double to BinaryInteger (Uint8, Uint16, Int8, and so on), truncate remains that do not fit in the instance of BinaryInteger range value.
    /// For instance, if Double value is 300.934, and self is UInt8, it will be 255, or if Float value is -100.2342, self value will be 0
    init(truncateToFit double: Double) {
        switch double {
        case _ where double < Double(Self.min): self.init(Self.min)
        case _ where double > Double(Self.max): self.init(Self.max)
        default: self.init(double)
        }
    }
}
public class AlgoLogic{
    
    private var MAX_COST = 20000;
       private var MAX_LENGTH = 1000;
       private var INTCBLOCK_OPCODE = 32;
       private var BYTECBLOCK_OPCODE = 38;
       private var PUSHBYTES_OPCODE = 128;
       private var PUSHINT_OPCODE = 129;
    
    private static var langSpec:LangSpec?
    private static var opcodes:[Operation?]?
    
 
    public static func putUVarint( value:Int)throws -> [Int8]  {
        if value <= 0{
            throw Errors.illegalArgumentError("putUVarint expects non-negative values.")
        }
        var funcValue=value

        var buffer:[Int8]=Array()

        
        while funcValue>=128 {
            buffer.append(Int8(truncatingIfNeeded: funcValue)&unsafeBitCast(UInt8(255), to:Int8.self)|unsafeBitCast(UInt8(128), to:Int8.self))
      
                funcValue =   funcValue>>7
      
     
        }
        buffer.append(Int8(truncatingIfNeeded: funcValue)&unsafeBitCast(UInt8(255), to: Int8.self))
  
        var out:[Int8]=Array()
        for i in 0..<buffer.count{
            out.append(buffer[i])
        }
        
           return out;
       }
 
    public static func getUVarint(buffer:[Int8],  bufferOffset:Int)->VarintResult {
          var x = 0;
          var s = 0;
       
        for i in 0..<buffer.count{
            var b:Int = Int(unsafeBitCast(buffer[bufferOffset + i], to: UInt8.self)  & 255)
            if b<128{
                if i<=9 && (i != 9 || b<=1){
                    return VarintResult(value: x | (Int(b) & 255) << s, length:  i + 1)
                }
            return VarintResult(value: 0, length: -(i + 1))
                
            }
            x |= (Int(b) & 127 & 255) << s;
            s += 7;
        }

          return VarintResult();
      }
    
    public static func loadLangSpec()   {
        let configURL = Bundle.module.path(forResource: "Langspec", ofType: "txt")
        let contensts = try! String(contentsOfFile: configURL!.description)
        let jsonData = contensts.data(using: .utf8)!
        let langspec = try! JSONDecoder().decode(LangSpec.self, from: jsonData)
        self.langSpec=langspec
       }
    
    
    public static func getLogicSigVersion() throws -> Int {
        if (langSpec == nil) {
            loadLangSpec();
        }

        return langSpec!.LogicSigVersion!;
    }

    public static func getEvalMaxVersion() throws ->Int {
           if (langSpec == nil) {
               loadLangSpec();
           }

           return langSpec!.EvalMaxVersion!;
       }
    
    
    
    public static func readByteConstBlock(program:[Int8], pc:Int)throws -> ByteConstBlock {
        var results:[[Int8]] = Array();
           var size = 1;
        var result:VarintResult = getUVarint(buffer: program, bufferOffset: pc + size);
           if (result.length <= 0) {
            throw Errors.illegalArgumentError("could not decode byte[] const block at \(pc)");
           } else {
                size = size + result.length;
               var numInts = result.value;

            for  i in 0..<numInts{
                if (pc+size) >= program.count{
                    throw Errors.illegalArgumentError("byte[] const block exceeds program length")
                }
                result = getUVarint(buffer: program, bufferOffset: pc+size)
                if result.length <= 0{
                    throw Errors.illegalArgumentError("could not decode int const \(i) block at \( pc + size)")
                }
                size = size + result.length
                if (pc+size) >= program.count{
                    throw Errors.illegalArgumentError("byte const block exceeds program length")
                }
                
                var buff:[Int8] = Array(repeating: 0, count: result.value)
                for i in 0..<result.value{
                    buff[i]=program[pc + size+i]
                }
                results.append(buff)
                size=size+result.value
            }

            return ByteConstBlock(size: size, results: results);
           }
       }
    
    public static func readIntConstBlock(program:[Int8],  pc:Int)throws->IntConstBlock {
        var results:[Int64] = Array()
          var size = 1;
        var result:VarintResult = getUVarint(buffer: program, bufferOffset: pc + size);
        
          if (result.length <= 0) {
            throw Errors.illegalArgumentError("could not decode int const block at \( pc)")
          } else {
            size = size + result.length
              var numInts = result.value;
            for i in 0..<numInts{
                if (pc+size) >= program.count{
                    throw Errors.illegalArgumentError("int const block exceeds program length")
                }
                result = getUVarint(buffer: program, bufferOffset: pc+size)
                if result.length<=0{
                    throw Errors.illegalArgumentError("could not decode int const \(i) block at \( pc + size)")
                }
                size = size + result.length
                
                results.append(Int64(result.value))
            }

            return IntConstBlock(size: size, results: results);
          }
      }
    
    public static func readProgram(program:[Int8],  args:[[Int8]]?) throws -> ProgramData {
        var ints:[Int64] = Array();
        var bytes:[[Int8]] = Array();
        var funcArgs=args
            if langSpec == nil {
                loadLangSpec();
            }

        var result:VarintResult = getUVarint(buffer: program, bufferOffset: 0);
            var vlen = result.length;
            if vlen <= 0 {
                throw Errors.illegalArgumentError("version parsing error");
            } else {
                var version = result.value;
                if (version > langSpec!.EvalMaxVersion!) {
                    throw Errors.illegalArgumentError("unsupported version");
                } else {
                    if (funcArgs == nil) {
                        funcArgs = Array();
                        }


                    var cost = 0;
                    var length = program.count;

                    var pc:Int=0;
                    while pc<funcArgs!.count{
                        length += funcArgs![pc].count
                      pc=pc+1
                    }
              
                    if (length > 1000) {
                        throw Errors.illegalArgumentError("program too long");
                    } else {
                        if opcodes == nil {
                            opcodes = Array(repeating: nil, count: 256);
                            pc=0
                            while pc<langSpec!.Ops!.count{
                                var op=langSpec?.Ops![pc]
                                opcodes![op!.Opcode!] = op!
                                pc=pc+1
                               
                            }
                           
                        }
                        pc=vlen
                        var size:Int=0;
                        while pc<program.count{
                            var opcode:Int=Int(program[pc] & unsafeBitCast(UInt8(255), to:Int8.self))
                           
                         
//                            if(opcode>=opcodes!.count||opcode<=0){
//                                throw Errors.illegalArgumentError("invalid instruction: \(opcode)")
//                            }
                           
                            let isIndexValid = opcodes!.indices.contains(opcode)
                            if(!isIndexValid){
                                throw Errors.illegalArgumentError("invalid instruction: \(opcode)")
                            }
                            var op=opcodes?[opcode]
                            cost = cost+op!.Cost!
                            size = op!.Size!
                            if size == 0{
                                switch(op!.Opcode){
                                case 32 : var intsBlock=try! readIntConstBlock(program: program, pc: pc)
                                    size = size + intsBlock.size
                                    ints.append(contentsOf: intsBlock.results)
                                case 38 : var bytesBlock=try! readByteConstBlock(program: program, pc: pc)
                                    size = size + bytesBlock.size
                                    bytes.append(contentsOf: bytesBlock.results)
                                    
                                case 129:
                                    var pushInt=try! readPushIntOp(program: program, pc: pc)
                                    size = size+pushInt.size
                                    ints.append(contentsOf: pushInt.results)
                                    
                                case 128:
                                    var pushBytes = try! readPushByteOp(program: program, pc: pc)
                                    size = size + pushBytes.size
                                    bytes.append(contentsOf: pushBytes.results)
                                    
                                default: throw Errors.illegalArgumentError("invalid instruction: ")
                                }
                            }
                            pc=pc+size
                        
                        }

                        if cost > 20000 {
                            throw Errors.illegalArgumentError("program too costly to run");
                        } else {
                            return ProgramData(good: true, intBlock: ints, byteBlock: bytes);
                        }
                    }
                }
            }
    }
    

    
   
    
    public static func readPushIntOp(program:[Int8], pc:Int)throws -> IntConstBlock{
        var size = 1
        var result:AlgoLogic.VarintResult = getUVarint(buffer: program, bufferOffset: pc+size)
        if result.length <= 0{
            throw Errors.illegalArgumentError("could not decode push int const at pc=\(pc)")
        }
        size+=result.length
        
        return IntConstBlock(size: size, results: [Int64(result.value)])
    }
    
    public static func readPushByteOp(program:[Int8], pc:Int)throws -> ByteConstBlock{
        var size = 1
        var result:VarintResult = getUVarint(buffer: program, bufferOffset: pc+size)
        if result.length <= 0{
            throw Errors.illegalArgumentError("could not decode push []byte const size at pc=\(pc)")
        }
        size += result.length
        if(pc+size+result.value>program.count){
            throw Errors.illegalArgumentError("pushbytes ran past end of program")
        }
        var buff:[Int8] = Array(repeating: 0, count: result.value)
        
        for i in 0..<buff.count{
              buff[i] =  program[pc+size+i]
        }
        size+=result.value
        return ByteConstBlock(size: size, results: [buff])
        
    }
    
  
    public static func checkProgram(program:[Int8],  args:[[Int8]]?) throws -> Bool {
       let programData = try readProgram(program: program, args: args)
        return programData.good
       }
    
    public  class VarintResult {
        public  var value:Int;
        public var length:Int;

        init(value:Int,length:Int) {
                self.value = value;
                self.length = length;
            }

            init() {
                self.value = 0;
                self.length = 0;
            }
        }

        public  class ProgramData {
            public  var good:Bool;
            public  var intBlock:[Int64];
            public  var byteBlock:[[Int8]];

            init(good:Bool,intBlock:[Int64],  byteBlock:[[Int8]]) {
                self.good = good;
                self.intBlock = intBlock;
                self.byteBlock = byteBlock;
            }
        }

    
    
    
    private class LangSpec:Codable {
        public var EvalMaxVersion:Int?
        public var LogicSigVersion:Int?
        public var Ops:[Operation]?

          init() {
           }
       }

    private class Operation:Codable {
        var Opcode:Int?
        var Name:String?
        var Cost:Int?
        var Size:Int?
        var Returns:String?
        var ArgEnum:[String]?
        var ArgEnumTypes:String?
        var Doc:String?
        var ImmediateNote:String?
        var Group:[String]?

          init() {
           }
       }

    
  public class IntConstBlock {
    public var size:Int
    public var results:[Int64];

    init(size:Int, results:[Int64]) {
            self.size = size;
            self.results = results;
        }
    }

 public  class ByteConstBlock {
    public var size:Int;
    public var results:[[Int8]];

    init(size:Int, results:[[Int8]]) {
            self.size = size;
            self.results = results;
        }
    }
}
