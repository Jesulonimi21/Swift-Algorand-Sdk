//
//  File.swift
//  
//
//  Created by Jesulonimi on 4/24/21.
//

import Foundation
import XCTest
import swift_algorand_sdk
public class LogicTests:XCTestCase{
    
    func testParseUvarint1(){
        var data:[Int8] = [1]
        var result:AlgoLogic.VarintResult = AlgoLogic.getUVarint(buffer: data, bufferOffset: 0)
        XCTAssertEqual(result.length, 1)
        XCTAssertEqual(result.value, 1)
    }
    
    func testParseUvarint2(){
        var data:[Int8] = [2]
        var result:AlgoLogic.VarintResult = AlgoLogic.getUVarint(buffer: data, bufferOffset: 0)
        XCTAssertEqual(result.length, 1)
        XCTAssertEqual(result.value, 2)
    }
    
    func testParseUvarint3(){
        var data:[Int8] = [123]
        var result:AlgoLogic.VarintResult = AlgoLogic.getUVarint(buffer: data, bufferOffset: 0)
        XCTAssertEqual(result.length, 1)
        XCTAssertEqual(result.value, 123)
    }
    
    func testParseUvarint4(){
        var data:[Int8] = [-56,3,]
        var result:AlgoLogic.VarintResult = AlgoLogic.getUVarint(buffer: data, bufferOffset: 0)
        XCTAssertEqual(result.length, 2)
        XCTAssertEqual(result.value, 456)
    }
    
    func testParseUvarint4AtOffset(){
        var data:[Int8] = [0,0,-56,3,]
        var result:AlgoLogic.VarintResult = AlgoLogic.getUVarint(buffer: data, bufferOffset: 2)
        XCTAssertEqual(result.length, 2)
        XCTAssertEqual(result.value, 456)
    }
    
    func testParseIntcBlock(){
        var data:[Int8] = [ 32,5,0,1,-56,3,123,2,]
        var results:AlgoLogic.IntConstBlock = try! AlgoLogic.readIntConstBlock(program: data, pc: 0)
        XCTAssertEqual(results.size, data.count)
        XCTAssert(results.results.elementsEqual([0, 1, 456, 123, 2]))
    }
  
    func testParseBytecBlock (){
        var data:[Int8] = [38,2,13,49,50,51,52,53,54,55,56,57,48,49,50,51,2,1,2,]
        var values:[[Int8]] = [[49,50,51,52,53,54,55,56,57,48,49,50,51,],[1,2,]]
        var results = try! AlgoLogic.readByteConstBlock(program: data, pc: 0)
        XCTAssertEqual(results.size, data.count)
        XCTAssert(results.results.elementsEqual(values))
      
    }
  
    func testParsePushIntOp(){
        var data:[Int8] = [-127,-128,-128,4,]
        var results:AlgoLogic.IntConstBlock = try! AlgoLogic.readPushIntOp(program: data, pc: 0)
        XCTAssertEqual(results.size, data.count)
    
        XCTAssert(results.results.elementsEqual([65536]))
        
    }
    
    func testParsePushBytesOp(){
        var data:[Int8] = [-128,11,104,101,108,108,111,32,119,111,114,108,100,]
        var values:[[Int8]] = [[104,101,108,108,111,32,119,111,114,108,100,]]
        var results =  try! AlgoLogic.readPushByteOp(program: data, pc: 0)
        XCTAssertEqual(results.size, data.count)
        XCTAssert(results.results.elementsEqual(values))
    }
    
    func testCheckProgramValid(){
        var program:[Int8] = [1,32,1,1,34,]
        var programData = try! AlgoLogic.readProgram(program: program, args: nil)
        XCTAssertTrue(programData.good)
        XCTAssert(programData.intBlock.elementsEqual([1]))
        XCTAssertEqual(programData.byteBlock, [])
        var args:[[Int8]] = Array()
        programData = try! AlgoLogic.readProgram(program: program, args: args)
        XCTAssertTrue(programData.good)
        XCTAssert(programData.intBlock.elementsEqual([1]))
        XCTAssertEqual(programData.byteBlock, [])
        var arg:[Int8] = [49,49,49,49,49,49,49,49,49,49]
        args.append(arg)
        programData = try! AlgoLogic.readProgram(program:program, args: args)
        XCTAssertTrue(programData.good)
        XCTAssert(programData.intBlock.elementsEqual([1]))
        XCTAssertEqual(programData.byteBlock, [])
        var int1:[Int8] = [34,34,34,34,34,34,34,34,34,34]
        var program2:[Int8] = Array(repeating: 0, count: program.count+int1.count)
        
        for i in 0..<program.count{
            program2[i] = program[i]
        }
        for i in 0..<int1.count{
            program2[i+program.count]=int1[i]
        }
        programData = try! AlgoLogic.readProgram(program:program2, args: args)
        XCTAssertTrue(programData.good)
        XCTAssert(programData.intBlock.elementsEqual([1]))
        XCTAssertEqual(programData.byteBlock, [])
    }
    
    
    func testCheckProgramLongArgs(){
        var program:[Int8] =  [1,32,1,1,34,]
        var args:[[Int8]] = Array(repeating: [49], count: 1000)
        
        
       
        var thrownError:Error?
        XCTAssertThrowsError(try AlgoLogic.readProgram(program: program, args: args)){
            thrownError = $0
        }
        XCTAssertTrue(thrownError is Errors, "Unexpected error type: \(type(of: thrownError))")
        
        XCTAssertEqual(thrownError as? Errors, .illegalArgumentError("program too long"))
        
    }

    func testCheckProgramLong(){
        var program:[Int8] =   [1,32,1,1,34]
        var int1:[Int8] = Array(repeating: 0, count: 1000)
        var program2:[Int8] = Array(repeating: 0, count: program.count+int1.count)
        var args:[[Int8]] = Array()
        for i in 0..<program.count{
            program2[i]=program[i]
        }
        for i in 0..<int1.count{
            program2.append(int1[i])
        }
        
        var thrownError:Error?
        XCTAssertThrowsError(try AlgoLogic.checkProgram(program: program2, args: args)){
            thrownError = $0
        }
        XCTAssertTrue(thrownError is Errors, "Unexpected error type: \(type(of: thrownError))")
        
        XCTAssertEqual(thrownError as? Errors, .illegalArgumentError("program too long"))
        
    }
    
    func testCheckProgramInvalidOpcode() {
        var program:[Int8] = [1,32,1,1,-1,]
        var args:[[Int8]] = Array()
        
        var thrownError:Error?
        XCTAssertThrowsError(try AlgoLogic.checkProgram(program: program, args: args)){
            thrownError = $0
        }
        XCTAssertTrue(thrownError is Errors, "Unexpected error type: \(type(of: thrownError))")
        
        XCTAssertEqual(thrownError as? Errors, .illegalArgumentError("invalid instruction: -1"))
    }
    
    func testCheckProgramTealV2(){
     try!   XCTAssertTrue(AlgoLogic.getEvalMaxVersion()>=2)
        try!   XCTAssertTrue(AlgoLogic.getLogicSigVersion()>=2)
       var program:[Int8] = [2,32,1,0,34,96]
        var valid = try! AlgoLogic.checkProgram(program: program, args: nil)
        XCTAssertTrue(valid)
            
        
        var program1:[Int8]=[2,32,1,0,34,34,97,]
        var valid1 = try! AlgoLogic.checkProgram(program: program1, args: nil)
        XCTAssertTrue(valid1)
        
        var program2:[Int8] = [2,32,1,0,34,112,0,]
        var valid2 = try! AlgoLogic.checkProgram(program: program2, args: nil)
        XCTAssertTrue(valid2)
    }

}
