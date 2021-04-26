//
//  File.swift
//  
//
//  Created by Jesulonimi on 3/5/21.
//

import Foundation
public class TxGroup : Encodable {
    private static var TG_PREFIX:[Int8]=[84,71,];
    public static var MAX_TX_GROUP_SIZE:Int=16
    private var txGroupHashes:[Digest]?;

    
    
    enum CodingKeys:String,CodingKey{
        case txGroupHashes="txlist"
    }
    
     init(txGroupHashes:[Digest]) {
        self.txGroupHashes=txGroupHashes
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var arrayOfData=Array(repeating: Data(), count: self.txGroupHashes!.count);
        
        for  i in 0..<self.txGroupHashes!.count{
            arrayOfData[i]=Data(CustomEncoder.convertToUInt8Array(input:self.txGroupHashes![i].getBytes()!))
        }
        
        try! container.encode(arrayOfData, forKey: .txGroupHashes)
    }
    


    public static func  computeGroupID(txns:[Transaction])throws -> Digest  {
        if (txns.count != 0) {
            if (txns.count > MAX_TX_GROUP_SIZE) {
                throw Errors.illegalArgumentError("max group size is \(MAX_TX_GROUP_SIZE)");
            } else {
                var txIDs:[Digest] = Array(repeating: Digest(), count: txns.count);

                for i in 0..<txns.count {
                    txIDs[i] = txns[i].rawTxID();
                }
                var txgroup:TxGroup = TxGroup(txGroupHashes: txIDs);

                var gid:[Int8] = try! SHA512_256().hash(txgroup.bytesToSign())
                
                    return  Digest(gid);
            
        }
    }else {
        throw Errors.illegalArgumentError("empty transaction list");
    }
        
    }

    public static func assignGroupID(txns:[Transaction]) throws -> [Transaction]  {
    return try! assignGroupID(txns, nil);
    
    }

    public static func assignGroupID(_ address:Address, _ txns:[Transaction]) throws -> [Transaction] {
        return try!  assignGroupID(txns, address);
    }


    public static func assignGroupID(_ txns:[Transaction], _ address:Address?) throws -> [Transaction] {
        var gid:Digest = try! self.computeGroupID(txns:txns);
        var result:[Transaction] = Array();
        var var4 = txns;
        var var5 = txns.count;


        for i in 0..<var5{
            var tx = var4[i]
            tx.assignGroupID(gid: gid)
            result.append(tx)
        }

        return result
    }

    private  func  bytesToSign() throws  ->[Int8]{
    var encodedTx:[Int8] = CustomEncoder.encodeToMsgPack(self);
//        print("Digest hash")
//        print(encodedTx)
//        var total:Int64=0//Int64(encodedTx.reduce(0, +))
//        for number in encodedTx{
//            total += Int64(number)
//        }
//        print(total)
//
        var prefixEncodedTx:[Int8] = Array(repeating: 0, count: TxGroup.TG_PREFIX.count+encodedTx.count)
        for i in 0..<TxGroup.TG_PREFIX.count{
            prefixEncodedTx[i]=TxGroup.TG_PREFIX[i]
    }
    var counter=0;
        for i in TxGroup.TG_PREFIX.count..<prefixEncodedTx.count{
        prefixEncodedTx[i]=encodedTx[counter]
        counter=counter+1
    }
    return prefixEncodedTx;
     
    }
   

    
}
