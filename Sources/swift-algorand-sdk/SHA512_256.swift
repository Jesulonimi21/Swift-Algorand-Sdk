//
//  File.swift
//  
//
//  Created by Jesulonimi on 1/30/21.
//

import Foundation

class SHA512_256{
    
    
    func hash(_ bytes:[Int8])->[Int8]{
    var logic=Logic()
      var  input = logic.pad(bytes);
        for i in 0..<input.count{
//            print("input after count: \(input[i])")
        }
      

    // Break the padded input up into blocks
        var  blocks:[[Int64]] = logic.toBlocks(input);
    
    // And get the expanded message blocks
        var W:[[Int64]] = logic.Message(blocks);
    
    // Set up the buffer which will eventually contain the final hash
    // Initially, it's set to the constants provided as part of the algorithm
        var buffer:[Int64] = Constants.IV.map{(UInt64Var) -> Int64 in
            return unsafeBitCast(UInt64Var, to:Int64.self)
        };

    // For every block
        for i in 0..<blocks.count {
        // a-h is set to the buffer initially
        var a = buffer[0];
        var b = buffer[1];
        var c = buffer[2];
        var d = buffer[3];
        var e = buffer[4];
        var f = buffer[5];
        var g = buffer[6];
        var h = buffer[7];
        
        // Run 80 rounds of the SHA-512 compression function on a-h
        for j in 0..<80 {
        var t1 = h &+ logic.Sigma1(e) &+ logic.Ch(e, f, g) &+ unsafeBitCast(Constants.K[j], to:Int64.self)  &+ W[i][j];
        var t2 = logic.Sigma0(a) &+ logic.Maj(a, b, c);
        h = g;
        g = f;
        f = e;
        e = d &+ t1;
        d = c;
        c = b;
        b = a;
        a = t1 &+ t2;
        

        }

        // After finishing the compression, save the state to the buffer
        buffer[0] = a &+ buffer[0];
        buffer[1] = b &+ buffer[1];
        buffer[2] = c &+ buffer[2];
        buffer[3] = d &+ buffer[3];
        buffer[4] = e &+ buffer[4];
        buffer[5] = f &+ buffer[5];
        buffer[6] = g &+ buffer[6];
        buffer[7] = h &+ buffer[7];

    }
        var result:[Int8]=Array(repeating: 0, count: 32)
        var resultCouinter=0;
//    print("Byte array print begin");
        for i in 0..<4{
//            System.out.print(b+" ");
            var x:[Int8] = longtoBytes(buffer[i]);
            for j in 0..<x.count{
//           print("\(x[j]) ");
                result[resultCouinter]=x[j]
                
                resultCouinter=resultCouinter+1
        }
    }
        return result
    
    }
    
    func longtoBytes(_ data:Int64) -> [Int8] {
        var a =   unsafeBitCast(UInt8((data >> 56) & 0xff),to:Int8.self)
        var b =      unsafeBitCast(UInt8((data >> 48) & 0xff),to:Int8.self)
        var c =   unsafeBitCast(UInt8((data >> 40) & 0xff),to:Int8.self)
      var d =       unsafeBitCast(UInt8((data >> 32) & 0xff),to:Int8.self)
       var e =              unsafeBitCast(UInt8((data >> 24) & 0xff),to:Int8.self)
         var f =  unsafeBitCast(UInt8((data >> 16) & 0xff),to:Int8.self)
         var g =                     unsafeBitCast(UInt8((data >> 8) & 0xff),to:Int8.self)
        var h =                    unsafeBitCast(UInt8((data >> 0) & 0xff),to:Int8.self)
      
      
      return [a,b,c,d,e,f,g,h]
       
      }

}
