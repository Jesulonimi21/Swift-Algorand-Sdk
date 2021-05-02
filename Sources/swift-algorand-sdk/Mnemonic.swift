//
//  File.swift
//  
//
//  Created by Jesulonimi on 1/30/21.
//

import Foundation
public class Mnemonic{
    static var   CHECKSUM_LEN_WORDS = 1
   static  var   MNEM_LEN_WORDS = 25
static  public  func toKey( _ mnemonicStr: String) throws ->[Int8] {
  
        var mnemonic:[String] = mnemonicStr.split{$0 == " "}.map(String.init)
 
            if (mnemonic.count != 25) {
                throw Errors.illegalArgumentError("mnemonic does not have enough words")
            } else {
                var numWords:Int = 24;
                var uint11Arr:[Int] = Array(repeating:0, count:24);// suppposed to be [numOfWords]
    
                var w:Int=0;
                for w in 0..<numWords {
                    uint11Arr[w] = -1;
    
                }

    
                for w in 0..<Constants.RAW.count{
                    for i in 0..<numWords{
                        if (Constants.RAW[w]==(mnemonic[i])) {
                            uint11Arr[i] = w;
                        }
                    }
                }

                for w in 0..<numWords{
                    if (uint11Arr[w] == -1) {
                        throw Errors.illegalArgumentError("mnemonic contains word that is not in word list")
                    }
                }
    
    
                var b:[Int8] = toByteArray(uint11Arr);
                if (b.count != 33) {
                    throw Errors.generalSecurityError("Wrong key length")
                } else if (b[32] != 0) {
                    throw Errors.generalSecurityError("unexpected byte from key")
                } else {

                    if b[b.count-1]==0{
                        b.remove(at: b.count-1)
                    }
                    var bCopy:[Int8] = b;
                    var chkWord = checksum(bCopy)
                    if (chkWord != mnemonic[24]) {
                        throw Errors.generalSecurityError("checksum failed to validate");
                           }
                    return b;
                }
            }
        return []
        }
    
    
    private static  func toByteArray(  _ arr:[Int]) -> [Int8]{
        var buffer:Int = 0;
        var numBits:Int = 0;
        var computOutValue=(arr.count * 11 + 8 - 1) / 8
        var out:[Int8] = Array(repeating:0, count:33);
        var ink:[UInt8] = Array(repeating:0, count:33);
        var j:Int = 0;

        for i in 0..<arr.count {
                buffer = buffer | arr[i] << numBits;

                numBits=numBits+11
    
            while( numBits >= 8) {

                out[j] = unsafeBitCast(UInt8((buffer & 255)), to:Int8.self);
                ink[j] = UInt8((buffer & 255));
                j=j+1;
                buffer >>= 8;
                numBits=numBits-8
            }

            }
    
            if (numBits != 0) {
                out[j] = Int8((buffer & 255));
            }
    
            return out;
        }
    
    
    private     static  func  toUintNArray(_ arr:[Int8]) ->[Int]{
         var buffer = 0;
         var numBits = 0;
        var out:[Int] = Array(repeating: 0, count: (arr.count * 8 + 11 - 1) / 11)
         var j = 0;

        for i in 0..<arr.count{
            var v:Int = Int(arr[i]);
             if (v < 0) {
                v =  v + 256;
             }

             buffer |= Int( v << numBits);
             numBits += 8;
             if (numBits >= 11) {
                 out[j] = buffer & 2047;
                 j=j+1;
                 buffer >>= 11;
                 numBits -= 11;
             }
         }

         if (numBits != 0) {
             out[j] = buffer & 2047;
         }

         return out;
     }
    private static  func   applyWord(_ iN:Int)->String {
        return Constants.RAW[iN];
       }

    private static func  checksum(_ data:[Int8]) -> String {
        var d:[Int8] = SHA512_256().hash(data);
        var checksum:[Int8]=Array(repeating: 0, count: 2)
        for i in 0...1{
            checksum[i]=d[i]
        }

        return applyWord(toUintNArray(checksum)[0]);
           
        }
    private static func  applyWords(_ arrN:[Int]) -> [String]{
        var ret = Array(repeating: "", count: arrN.count)
        for  i in 0..<arrN.count {
                ret[i] = applyWord(arrN[i]);
            }

            return ret;
        }
    private static func  mnemonicToString( _ mnemonic:[String],_ checksum:String) -> String {
        var s:String = "";

        for i in 0..<mnemonic.count{
               if (i > 0) {
                   s.append(" ");
               }

               s.append(mnemonic[i]);
           }

           s.append(" ");
           s.append(checksum);
           return s;
       }



    public static func  fromKey(_ key:[Int8])throws -> String {
          
           if (key.count != 32) {
            throw Errors.illegalArgumentError("key length must be 32 bytes");
           } else {
            var chkWord:String = checksum(key);
            var uint11Arr:[Int] = toUintNArray(key);
            var words:[String] = applyWords(uint11Arr);
               return mnemonicToString(words, chkWord);
           }
       }
}
