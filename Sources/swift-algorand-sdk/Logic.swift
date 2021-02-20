//
//  File.swift
//  
//
//  Created by Jesulonimi on 1/28/21.
//

import Foundation
infix operator >>> : BitwiseShiftPrecedence
func >>> (lhs: Int64, rhs: Int64) -> Int64 {
   if lhs >= 0 {
          return lhs >> rhs
      } else {
          return (Int64.max + lhs + 1) >> rhs | (1 << (63-rhs))
      }
}
class Logic {
    typealias Byte = UInt8

    func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
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
 

   
    
    // Used in the compression function
    func  Ch(_ x:Int64, _ y:Int64,_ z:Int64) -> Int64 {
        return (x & y) ^ (~x & z);
    }
    
    // Used in the compression function
    func Maj(_ x:Int64,_ y:Int64, _ z:Int64) ->Int64{
        return (x & y) ^ (x & z) ^ (y & z);
    }
    
    // Used in the compression function
    func  rotate( _ x:Int64,  _ l:Int) ->Int64{
        if x >= 0 {
              return x >> l |  (x << (Int(64) - l))
          } else {
             var resp = (Int64.max + x + 1) >> l | (1 << (Int(63)-l))
            resp=resp |  (x << (Int(64) - l))
            return resp;
          }
    }
    

    // Used in the compression function
    // Sn = right rotate by n bits
    // Rn = right shift by n bits
    func  Sigma0(_ x:Int64)->Int64 {
        // S28(x) ^ S34(x) ^ S39(x)
        return rotate(x,28) ^ rotate(x, 34) ^ rotate(x, 39);
    }

    // Used in the compression function
 func Sigma1(_ x:Int64) ->Int64{
        // S14(x) ^ S18(x) ^ S41(x)
        return rotate(x, 14) ^ rotate(x, 18) ^ rotate(x, 41);
    }

    // Used in the message schedule
    func _Sigma0(_  x:Int64)->Int64 {
        // S1(x) ^ S8(x) ^ R7(x)
        //removed ">"
        return rotate(x, 1) ^ rotate(x, 8) ^ (x >>> 7);
    }

    // Used in the message schedule
    func _Sigma1(_  x:Int64)->Int64 {
        // S19(x) ^ S61(x) ^ R6(x)
        //removed >
        var rVal = rotate(x, 19) ^ rotate(x, 61) ;
        return rVal ^ (x >>> 6)
    }

    // Pads the input byte array
    func  pad(_ input:[Int8]) ->[Int8]{
        // Need to append at least 17 bytes (16 for length of the message, and 1 for the '1' bit)
        // then fill with 0s until multiple of 128 bytes
        var size = input.count + 17;
        while (size % 128 != 0) {
            size += 1;
        }

        // The padded byte array
        var out:[Int8] =  Array(repeating:0, count:size);

        // Copy over the old stuff
        for i in 0..<input.count {
            out[i] = input[i];
        }

        // Add the '1' bit
        out[input.count] = -128;

        

        var lenInBytes:[Int8]=longtoBytes(Int64(input.count*8))
        // And put it at the end of our padded input
        var i=lenInBytes.count;
        while (i > 0) {
            out[size - i] = lenInBytes[lenInBytes.count - i]
            i=i-1
        }



        return out;
    }

    //Converts the byte array input starting at index j into a long
    func arrToLong(_ input:[Int8],  _ j:Int) ->Int64{
        var v:Int64 = 0;
        for i in 0..<8 {
            v = (v << 8) + (Int64(input[i + j]) & 0xff);


        }
        return v;
    }

    // Converts the byte array input into blocks of longs
    func  toBlocks(_ input:[Int8])->[[Int64]] {

        // a block has: 1024 bits = 128 bytes = 16 longs
        var blocks:[[Int64]] = Array(repeating: Array(repeating: 0, count: 16), count:input.count / 128);

        // For every block
        for i in 0..<input.count/128 {
            // For each long in a block
            for j in 0..<16{
                // Set the block value to the correct one
                blocks[i][j] = arrToLong(input, i * 128 + j * 8);
            }
        }
        return blocks;
    }


    // Calculates the expanded message blocks W0-W79
    func Message(_ M:[[Int64]])->[[Int64]] {
        var W:[[Int64]] = Array(repeating: Array(repeating: 0, count: 80), count: M.count);

        // For each block in the input
        for i in 0..<M.count {

            // For each long in the block
            for j in 0..<16 {
                // Set the initial values of W to be the value of the input directly
                W[i][j] = M[i][j];

            }

            // For the rest of the values
            for j in 16..<80 {
                // Do some math from the SHA512 algorithm

                var s1 = _Sigma1(W[i][j-2])
                var eq2 = W[i][j-7]
                var s2 = _Sigma0(W[i][j-15])
                var eq3  = W[i][j-16]

                W[i][j] = s1 &+ (s2) &+ eq2 &+ eq3
            }

        }

        return W;
    }
}
