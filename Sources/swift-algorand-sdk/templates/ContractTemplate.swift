//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/22/21.
//

import Foundation


public class ContractTemplate {
    public var address:Address
    public var program:[Int8]

    public convenience init(prog:String) {
        self.init(prog: CustomEncoder.convertToInt8Array(input: CustomEncoder.convertBase64ToByteArray(data1: prog)));
    }

    public convenience init (prog:[Int8]){
      try!  self.init(lsig: LogicsigSignature(logicsig: prog));
    }

    public init(lsig:LogicsigSignature)  {
        self.address = try! lsig.toAddress();
        self.program = lsig.logic!;
    }
    
    
    public  static func inject(program:[Int8], values:[ContractTemplate.ParameterValue]) throws -> ContractTemplate {
        var updatedProgram:[Int8] = Array()
        var progIdx = 0;
        var value:ContractTemplate.ParameterValue
        for i in 0..<values.count{
            value=values[i]

            while progIdx<value.getOffset(){
                updatedProgram.append(program[progIdx])

                progIdx=progIdx+1
              

            }
            var var6:[Int8]=value.toBytes()
            var var7:Int=var6.count
            var var8=0
            while var8<var7{
                var b:Int8=var6[var8]
                updatedProgram.append(b)
                var8=var8+1
               
            }
            

                progIdx=progIdx+values[i].placeholderSize()


        }
        while progIdx < program.count {
            updatedProgram.append(program[progIdx])
            progIdx=progIdx+1
        }
        var updatedProgramByteArray:[Int8]=Array(repeating: 0, count: updatedProgram.count)
        for i in 0..<updatedProgram.count{
            updatedProgramByteArray[i]=updatedProgram[i]
        }
        return ContractTemplate(prog: updatedProgramByteArray)

    }
    


    public static func readAndVerifyContract(program:[Int8],  numInts:Int,  numByteArrays:Int) throws ->AlgoLogic.ProgramData{
    var data:AlgoLogic.ProgramData;
        data = try AlgoLogic.readProgram(program: program, args: nil)
       
    if (data.good && data.intBlock.count == numInts && data.byteBlock.count == numByteArrays) {
        return data;
    } else {
        throw Errors.illegalArgumentError("Invalid contract detected.");
    }
    }

    public class ParameterValue {
        private var offset:Int
        private var value:[Int8];

        public init ( offset:Int, value:[Int8]) {
            self.value = value;
            self.offset = offset;
        }

        public func toBytes() ->[Int8] {
            return self.value;
        }

        public func getOffset() ->Int {
            return self.offset;
        }
        public  func placeholderSize() ->Int{
            return 0;
        }
    }

    
    public  class BytesParameterValue : ContractTemplate.ParameterValue {
        public convenience init(offset:Int, value:String) {
            self.init(offset:offset,value: CustomEncoder.convertToInt8Array(input:CustomEncoder.convertBase64ToByteArray(data1: value)));
        }

        public  override init(offset:Int,value:[Int8]) {
            super.init(offset:offset, value:
                        Self.convertToBytes(value: value));
        }

        public convenience init(offset:Int, value:Lease) {
            self.init(offset:offset, value:value.getBytes());
        }
        
        public override func placeholderSize() ->Int{
            return 2;
        }

        private static func convertToBytes(value:[Int8]) ->[Int8]{
            var len = try! AlgoLogic.putUVarint(value:value.count);
            var result:[Int8] = Array(repeating: 0, count: len.count + value.count)
                
            for i in 0..<len.count{
                result[0]=len[i]
            }

            
            for i in 0..<value.count{
                result[i+len.count]=value[i]
            }
            return result;
        }
        

     
    }


    public class AddressParameterValue : ContractTemplate.ParameterValue {
        public convenience init(offset:Int,  value:String) {
            self.init(offset:offset, value:(try! Address(value)).getBytes())
   
          
        }

        public convenience init (offset:Int, address:Address) {
            self.init(offset:offset,value: address.getBytes());
        }

        public  override init(offset:Int, value:[Int8]) {
            super.init(offset:offset, value:value);
        }

        public override func placeholderSize() -> Int{
            return 32;
        }
    }
    

    
    public  class IntParameterValue : ContractTemplate.ParameterValue {
        public convenience init(offset:Int,value:Int) {
            
           try! self.init(offset:offset, value:AlgoLogic.putUVarint(value:value));
        }

        public override func placeholderSize()->Int {
            return 1;
        }
    }

}
