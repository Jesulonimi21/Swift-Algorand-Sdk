//
//  File.swift
//  
//
//  Created by Jesulonimi on 4/24/21.
//

import Foundation
import swift_algorand_sdk
import XCTest
import Ed25519

public class TransactionTests:XCTestCase{
static var DEFAULT_ACCOUNT = try initializeDefaultAccount();
    public static  func initializeDefaultAccount()  ->Account{
        var mnemonic =  "awful drop leaf tennis indoor begin mandate discover uncle seven only coil atom any hospital uncover make any climb actor armed measure need above hundred"
        return  try! Account(mnemonic)
    }
    
    private func assertEqual(actual:Transaction, expected:Transaction) {
        XCTAssertEqual(actual, expected)
        XCTAssertEqual(actual.sender, expected.sender)
        XCTAssertEqual(actual.receiver , expected.receiver)
        XCTAssertEqual(actual.amount, expected.amount)
        XCTAssertEqual(actual.lastValid, expected.lastValid)
        XCTAssertEqual(actual.genesisHash, expected.genesisHash)
       }
    
    func testSerialization ()throws{
        var from = try Address("VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ")
        var to = try Address("CQW2QBBUW5AGFDXMURQBRJN2AM3OHHQWXXI4PEJXRCVTEJ3E5VBTNRTEAE")
        var tx = try Transaction.paymentTransactionBuilder().setSender(from).receiver(to).amount(100).firstValid(301).lastValid(1300).genesisHash(Digest()).build()
        let jsonData = try JSONEncoder().encode(tx)
        var o = try JSONDecoder().decode(Transaction.self, from: jsonData)
        XCTAssertEqual(tx, o)
    }
     
    func testSerializationMsgpack()throws{
        var from = try Address("VKM6KSCTDHEM6KGEAMSYCNEGIPFJMHDSEMIRAQLK76CJDIRMMDHKAIRMFQ")
        var to = try Address("CQW2QBBUW5AGFDXMURQBRJN2AM3OHHQWXXI4PEJXRCVTEJ3E5VBTNRTEAE")
        var tx = try Transaction.paymentTransactionBuilder().setSender(from).receiver(to).amount(100).firstValid(301).lastValid(1300).genesisHash(Digest()).build()
        var outBytes:[UInt8] = try CustomEncoder.encodeToMsgPack(tx)
        var o =  try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(outBytes))
        XCTAssertEqual(o, tx)
    }
    
    func createAssetTest (numDecimal:Int64,goldenString:String)throws{
        var addr = try Address("BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4")
        var gh = CustomEncoder.convertToInt8Array(input:  CustomEncoder.decodeByteFromBase64(string: "SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI="))
        var sender = addr
        var manager = addr
        var reserve = addr
        var freeze = addr
        var clawback = addr
        var metadataHash =  "fACPO4nRgO55j1ndAK3W6Sgc4APkcyFh"
        
        var tx = try Transaction.assetCreateTransactionBuilder().setSender(sender).fee(10).firstValid(322575).lastValid(323575)
            .genesisHash(gh).setAssetTotal(assetTotal: 100).setAssetDecimals(assetDecimals: numDecimal).assetUnitName(assetUnitName:  "tst").assetName(assetName: "testcoin").url(url: "website").metadataHashUTF8(metadataHash: metadataHash).manager(manager: manager).reserve(reserve: reserve).freeze(freeze: freeze).clawback(clawback: clawback).build()
        
        var assetParams = try AssetParams(assetTotal: 100, assetDecimals: numDecimal, assetDefaultFrozen: false, assetUnitName: "tst", assetName: "testcoin", url: "website", metadataHash: CustomEncoder.convertToInt8Array(input: metadataHash.bytes), assetManager: manager, assetReserve: reserve, assetFreeze: freeze, assetClawback: clawback)
        XCTAssertEqual(assetParams, tx.assetParams)
        
      
        var stx = try TransactionTests.DEFAULT_ACCOUNT.signTransaction(tx: tx)
        var msgPack:[UInt8] = try CustomEncoder.encodeToMsgPack(stx)
        var encodedOut = try CustomEncoder.encodeToBase64(msgPack)
        var decodedOut = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(msgPack))
     
        XCTAssertEqual(decodedOut, stx)
   
        XCTAssertEqual(encodedOut,goldenString )
        try TestUtil.serializeDeserializeCheck(object: stx);
     }
    
    func testAssetParamsValidation() throws {
        var addr = try Address("BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4")
        var manager = addr
        var reserve = addr
        var freeze = addr
        var clawback = addr
        var badMetadataHash = "fACPO4nRgO55j1ndAK3W6Sgc4APkcyF!"
        var tooLongMetadataHash = "fACPO4nRgO55j1ndAK3W6Sgc4APkcyFhfACPO4nRgO55j1ndAK3W6Sgc4APkcyFh"

   
        var str =  badMetadataHash.removingAllWhitespaces.padding(toLength: ((badMetadataHash.count+3)/4)*4,
                                                         withPad: "=",
                                                         startingAt: 0)
      
        var thrownError1:Error?
        XCTAssertThrowsError(try AssetParams(assetTotal: 100, assetDecimals: 3, assetDefaultFrozen: false, assetUnitName: "tst", assetName: "testcoin", url: "website", metadataHash: CustomEncoder.convertToInt8Array(input: badMetadataHash.bytes), assetManager: manager, assetReserve: reserve, assetFreeze: freeze, assetClawback: clawback)){
            thrownError1 = $0
        }
        XCTAssertTrue(thrownError1 is Errors, "Unexpected error type: \(type(of: thrownError1))")

        XCTAssertEqual(thrownError1 as? Errors, .runtimeError("asset metadataHash \(badMetadataHash) is not base64 encoded"))
        
        var thrownError2:Error?
        XCTAssertThrowsError(try AssetParams(assetTotal: 100, assetDecimals: 3, assetDefaultFrozen: false, assetUnitName: "tst", assetName: "testcoin", url: "website", metadataHash: CustomEncoder.convertToInt8Array(input: tooLongMetadataHash.bytes), assetManager: manager, assetReserve: reserve, assetFreeze: freeze, assetClawback: clawback)){
            thrownError2 = $0
        }
        XCTAssertTrue(thrownError2 is Errors, "Unexpected error type: \(type(of: thrownError1))")

        XCTAssertEqual(thrownError2 as? Errors, .runtimeError("asset metadataHash cannot be greater than 32 bytes"))
    }
    
    func testMakeAssetCreateTxn()throws{
        try createAssetTest(numDecimal: 0, goldenString: "gqNzaWfEQEDd1OMRoQI/rzNlU4iiF50XQXmup3k5czI9hEsNqHT7K4KsfmA/0DUVkbzOwtJdRsHS8trm3Arjpy9r7AXlbAujdHhuh6RhcGFyiaJhbcQgZkFDUE80blJnTzU1ajFuZEFLM1c2U2djNEFQa2N5RmiiYW6odGVzdGNvaW6iYXWnd2Vic2l0ZaFjxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFmxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFtxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFyxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aF0ZKJ1bqN0c3SjZmVlzQ+0omZ2zgAE7A+iZ2jEIEhjtRiks8hOyBDyLU8QgcsPcfBZp6wg3sYvf3DlCToiomx2zgAE7/ejc25kxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aR0eXBlpGFjZmc=")
    }
    func testMakeAssetCreateTxnWithDecimals()throws{
        try createAssetTest(numDecimal: 1, goldenString: "gqNzaWfEQCj5xLqNozR5ahB+LNBlTG+d0gl0vWBrGdAXj1ibsCkvAwOsXs5KHZK1YdLgkdJecQiWm4oiZ+pm5Yg0m3KFqgqjdHhuh6RhcGFyiqJhbcQgZkFDUE80blJnTzU1ajFuZEFLM1c2U2djNEFQa2N5RmiiYW6odGVzdGNvaW6iYXWnd2Vic2l0ZaFjxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aJkYwGhZsQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2hbcQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2hcsQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2hdGSidW6jdHN0o2ZlZc0P3KJmds4ABOwPomdoxCBIY7UYpLPITsgQ8i1PEIHLD3HwWaesIN7GL39w5Qk6IqJsds4ABO/3o3NuZMQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2kdHlwZaRhY2Zn")
        
    }
    
    func testSerializationAssetConfig()throws{
        var addr =  try Address("BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4")
        var gh = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI="))
        var sender = addr
        var manager = addr
        var reserve = addr
        var freeze = addr
        var clawback = addr

        var tx = try Transaction.assetConfigureTransactionBuilder()
            .setSender(sender)
            .fee(10)
            .firstValid(322575)
            .lastValid(323575)
            .genesisHash(gh)
            .manager(manager: manager)?
            .assetIndex(assetIndex: 1234)
            .reserve(reserve: reserve)?
            .freeze(freeze: freeze)?
            .clawback(clawback: clawback)?
            .build()
        var stx = try TransactionTests.DEFAULT_ACCOUNT.signTransaction(tx: tx!)
        var encodedOutbytes:[UInt8] = try CustomEncoder.encodeToMsgPack(stx)
        var goldenString = "gqNzaWfEQBBkfw5n6UevuIMDo2lHyU4dS80JCCQ/vTRUcTx5m0ivX68zTKyuVRrHaTbxbRRc3YpJ4zeVEnC9Fiw3Wf4REwejdHhuiKRhcGFyhKFjxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFmxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFtxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aFyxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aRjYWlkzQTSo2ZlZc0NSKJmds4ABOwPomdoxCBIY7UYpLPITsgQ8i1PEIHLD3HwWaesIN7GL39w5Qk6IqJsds4ABO/3o3NuZMQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2kdHlwZaRhY2Zn"
     
        var o = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(encodedOutbytes))
        XCTAssertEqual(encodedOutbytes, CustomEncoder.convertBase64ToByteArray(data1: goldenString) )
    
        XCTAssertEqual(o, stx)
        try TestUtil.serializeDeserializeCheck(object: stx);
        
    }

    
    func testAssetConfigStrictEmptyAddressChecking()throws{
        var addr = try Address("BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4")
        var gh = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI="))
        var sender = addr
        var manager = addr
        var reserve = addr
        var freeze = addr
    
        
          var thrownError1:Error?
          XCTAssertThrowsError(try Transaction.assetConfigureTransactionBuilder()
                                .setSender(sender)
                                .fee(10)
                                .firstValid(322575)
                                .lastValid(323575)
                                .genesisHash(gh)
                                .manager(manager: manager)?
                                .assetIndex(assetIndex: 1234)
                                .reserve(reserve: reserve)?
                                .freeze(freeze: freeze)?
                                .clawback(clawback: Address())?
                                .build()){
              thrownError1 = $0
          }
          XCTAssertTrue(thrownError1 is Errors, "Unexpected error type: \(type(of: thrownError1))")

          XCTAssertEqual(thrownError1 as? Errors, .runtimeError("strict empty address checking requested but empty or default address supplied to one or more manager addresses"))
          
    }
    
    func testSerializationAssetFreeze()throws{
        var addr = try Address("BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4")
        var gh = CustomEncoder.convertToInt8Array(input:  CustomEncoder.decodeByteFromBase64(string: "SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI="))
        var sender = addr
        var target = addr
        var assetFreezeID:Int64  = 1
        var freezeState = true
        var tx = try Transaction.assetFreezeTransactionBuilder().setSender(sender).freezeTarget(freezeTarget: target).freezeState(freezeState: freezeState).fee(10).firstValid(322575).lastValid(323576).genesisHash(gh).assetIndex(assetIndex: assetFreezeID).build()
        var stx = try TransactionTests.DEFAULT_ACCOUNT.signTransaction(tx: tx)
        var msgPack:[UInt8] = try CustomEncoder.encodeToMsgPack(stx)
        var encodedOutBytes = try CustomEncoder.encodeToBase64(Data(msgPack))
        var o = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(msgPack))
        var goldenString = "gqNzaWfEQAhru5V2Xvr19s4pGnI0aslqwY4lA2skzpYtDTAN9DKSH5+qsfQQhm4oq+9VHVj7e1rQC49S28vQZmzDTVnYDQGjdHhuiaRhZnJ6w6RmYWRkxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aRmYWlkAaNmZWXNCRqiZnbOAATsD6JnaMQgSGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiKibHbOAATv+KNzbmTEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9pHR5cGWkYWZyeg=="
        XCTAssertEqual(encodedOutBytes, goldenString)
   
        XCTAssertEqual(o, stx)
       
        try TestUtil.serializeDeserializeCheck(object: stx);
    }
    
    func testPaymentTransaction()throws{
        var FROM_SK = "advice pudding treat near rule blouse same whisper inner electric quit surface sunny dismiss leader blood seat clown cost exist hospital century reform able sponsor"
        var seed = try Mnemonic.toKey(FROM_SK)
        var account = try Account(seed)
        var fromAddr = try Address("47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU")
        var toAddr = try Address("PNWOET7LLOWMBMLE4KOCELCX6X3D3Q4H2Q4QJASYIEOF7YIPPQBG3YQ5YI")
        var closeTo = try Address("IDUTJEUIEVSMXTU4LGTJWZ2UE2E6TIODUKU6UW3FU3UKIQQ77RLUBBBFLA")
        var goldenString = "gqNzaWfEQPhUAZ3xkDDcc8FvOVo6UinzmKBCqs0woYSfodlmBMfQvGbeUx3Srxy3dyJDzv7rLm26BRv9FnL2/AuT7NYfiAWjdHhui6NhbXTNA+ilY2xvc2XEIEDpNJKIJWTLzpxZpptnVCaJ6aHDoqnqW2Wm6KRCH/xXo2ZlZc0EmKJmds0wsqNnZW6sZGV2bmV0LXYzMy4womdoxCAmCyAJoJOohot5WHIvpeVG7eftF+TYXEx4r7BFJpDt0qJsds00mqRub3RlxAjqABVHQ2y/lqNyY3bEIHts4k/rW6zAsWTinCIsV/X2PcOH1DkEglhBHF/hD3wCo3NuZMQg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGkdHlwZaNwYXk="
        var firstValidRound:Int64 = 12466
        var lastValidRound: Int64 = 13466
        var amountToSend:Int64 = 1000
        var note = CustomEncoder.decodeByteFromBase64(string: "6gAVR0Nsv5Y=")
        var genesisID = "devnet-v33.0"
        var genesisHash = Digest(CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "JgsgCaCTqIaLeVhyL6XlRu3n7Rfk2FxMeK+wRSaQ7dI=")))

        var tx = try Transaction.paymentTransactionBuilder().setSender(fromAddr).fee(4).firstValid(firstValidRound).lastValid(lastValidRound).note(note).genesisID(genesisID).genesisHash(genesisHash).amount(amount: amountToSend).receiver(toAddr).closeRemainderTo(closeTo).build()
        
        var outBytes:[UInt8] = try CustomEncoder.encodeToMsgPack(tx)
        var o = try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(outBytes))
        XCTAssertEqual(o, tx)
       
        var stx = try account.signTransaction(tx: tx)
        var msgPack:[UInt8] = try CustomEncoder.encodeToMsgPack(stx)
        var encodedOutBytes = try CustomEncoder.encodeToBase64(Data(msgPack))
        var stxDecoded = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(msgPack))
        XCTAssertEqual(stx, stxDecoded)
        
        XCTAssertEqual(encodedOutBytes, goldenString)
        try TestUtil.serializeDeserializeCheck(object: stx);
        
    }
    
    
    func testTransactionGroup()throws{
        var from = try Address("UPYAFLHSIPMJOHVXU2MPLQ46GXJKSDCEMZ6RLCQ7GWB5PRDKJUWKKXECXI")
        var to = try Address("UPYAFLHSIPMJOHVXU2MPLQ46GXJKSDCEMZ6RLCQ7GWB5PRDKJUWKKXECXI")
        var fee:Int64=1000
        var amount:Int64 = 2000
        var genesisID:String = "devnet-v1.0"
        var genesisHash = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "sC3P7e2SdbqKJK0tbiCdK9tdSpbe6XeCGKdoNzmlj0E"))
        var firstRound1:Int64 = 710399
        var note1:[Int8] = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "wRKw5cJ0CMo="))
        var tx1 = try Transaction.paymentTransactionBuilder().setSender(from).flatFee(fee).firstValid(firstRound1).lastValid(firstRound1+1000).note(note1).genesisID(genesisID).genesisHash(genesisHash).amount(amount: amount).receiver(to).build()
        
        var firstRound2:Int64 = 710515
        var note2:[Int8] =  CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "dBlHI6BdrIg="))
        var tx2 = try Transaction.paymentTransactionBuilder().setSender(from).flatFee(fee).firstValid(firstRound2).lastValid(firstRound2+1000).note(note2).genesisID(genesisID).genesisHash(genesisHash).amount(amount: amount).receiver(to).build()
        
        var fRoundMsgPack1:[UInt8] = try CustomEncoder.encodeToMsgPack(tx1)
        var fRoundMsgPack2:[UInt8] = try CustomEncoder.encodeToMsgPack(tx2)
        XCTAssertEqual(try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(fRoundMsgPack1)), tx1)
        XCTAssertEqual(try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(fRoundMsgPack2)), tx2)
        
        var goldenTx1 = "gaN0eG6Ko2FtdM0H0KNmZWXNA+iiZnbOAArW/6NnZW6rZGV2bmV0LXYxLjCiZ2jEILAtz+3tknW6iiStLW4gnSvbXUqW3ul3ghinaDc5pY9Bomx2zgAK2uekbm90ZcQIwRKw5cJ0CMqjcmN2xCCj8AKs8kPYlx63ppj1w5410qkMRGZ9FYofNYPXxGpNLKNzbmTEIKPwAqzyQ9iXHremmPXDnjXSqQxEZn0Vih81g9fEak0spHR5cGWjcGF5"
        var goldenTx2 = "gaN0eG6Ko2FtdM0H0KNmZWXNA+iiZnbOAArXc6NnZW6rZGV2bmV0LXYxLjCiZ2jEILAtz+3tknW6iiStLW4gnSvbXUqW3ul3ghinaDc5pY9Bomx2zgAK21ukbm90ZcQIdBlHI6BdrIijcmN2xCCj8AKs8kPYlx63ppj1w5410qkMRGZ9FYofNYPXxGpNLKNzbmTEIKPwAqzyQ9iXHremmPXDnjXSqQxEZn0Vih81g9fEak0spHR5cGWjcGF5"
        
        var stx1 = SignedTransaction(tx: tx1, sig: Signature(), mSig: MultisigSignature(), lSig: LogicsigSignature(), txId: try tx1.txID())
        var stx2 = SignedTransaction(tx: tx2, sig: Signature(), mSig: MultisigSignature(), lSig: LogicsigSignature(), txId: try tx2.txID())
        
        
        var expectedmSGpACK:[UInt8] = CustomEncoder.decodeByteFromBase64(string: goldenTx1)
        var expectedStx = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(expectedmSGpACK))
        
        try TestUtil.serializeDeserializeCheck(object: stx1);
        try TestUtil.serializeDeserializeCheck(object: stx2);
        
        var fRoundMsgPackStx1:[UInt8] = try CustomEncoder.encodeToMsgPack(stx1)
        var fRoundMsgPackStx2:[UInt8] = try CustomEncoder.encodeToMsgPack(stx2)
        XCTAssertEqual(try CustomEncoder.encodeToBase64(fRoundMsgPackStx1), goldenTx1)
        XCTAssertEqual(try CustomEncoder.encodeToBase64(fRoundMsgPackStx2), goldenTx2)
        
        var gid = try TxGroup.computeGroupID(txns: [tx1,tx2])
        tx1.assignGroupID(gid: gid)
        tx2.assignGroupID(gid: gid)
        
        
        
         fRoundMsgPack1 = try CustomEncoder.encodeToMsgPack(tx1)
         fRoundMsgPack2 = try CustomEncoder.encodeToMsgPack(tx2)
        XCTAssertEqual(try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(fRoundMsgPack1)), tx1)
        XCTAssertEqual(try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(fRoundMsgPack2)), tx2)
        
        var goldenTxg = "gaN0eG6Lo2FtdM0H0KNmZWXNA+iiZnbOAArW/6NnZW6rZGV2bmV0LXYxLjCiZ2jEILAtz+3tknW6iiStLW4gnSvbXUqW3ul3ghinaDc5pY9Bo2dycMQgLiQ9OBup9H/bZLSfQUH2S6iHUM6FQ3PLuv9FNKyt09SibHbOAAra56Rub3RlxAjBErDlwnQIyqNyY3bEIKPwAqzyQ9iXHremmPXDnjXSqQxEZn0Vih81g9fEak0so3NuZMQgo/ACrPJD2Jcet6aY9cOeNdKpDERmfRWKHzWD18RqTSykdHlwZaNwYXmBo3R4boujYW10zQfQo2ZlZc0D6KJmds4ACtdzo2dlbqtkZXZuZXQtdjEuMKJnaMQgsC3P7e2SdbqKJK0tbiCdK9tdSpbe6XeCGKdoNzmlj0GjZ3JwxCAuJD04G6n0f9tktJ9BQfZLqIdQzoVDc8u6/0U0rK3T1KJsds4ACttbpG5vdGXECHQZRyOgXayIo3JjdsQgo/ACrPJD2Jcet6aY9cOeNdKpDERmfRWKHzWD18RqTSyjc25kxCCj8AKs8kPYlx63ppj1w5410qkMRGZ9FYofNYPXxGpNLKR0eXBlo3BheQ==";
        
         stx1 = SignedTransaction(tx: tx1, sig: Signature(), mSig: MultisigSignature(), lSig: LogicsigSignature(), txId: try tx1.txID())
         stx2 = SignedTransaction(tx: tx2, sig: Signature(), mSig: MultisigSignature(), lSig: LogicsigSignature(), txId: try tx2.txID())
        
        
         fRoundMsgPackStx1 = try CustomEncoder.encodeToMsgPack(stx1)
         fRoundMsgPackStx2 = try CustomEncoder.encodeToMsgPack(stx2)
        var ftx = fRoundMsgPackStx1 + fRoundMsgPackStx2
        
        XCTAssertEqual(try CustomEncoder.encodeToBase64(ftx), goldenTxg)
        
        var result =  try TxGroup.assignGroupID(txns:[tx1,tx2])
        XCTAssertEqual(result.count, 2)
        
         result =  try TxGroup.assignGroupID(from, [tx1,tx2])
        XCTAssertEqual(result.count, 2)
        
        result =  try TxGroup.assignGroupID(to, [tx1,tx2])
        XCTAssertEqual(result.count, 2)
    }

    
    public func testTransactionGroupLimit()throws{
        var txs:[Transaction] = Array(repeating: Transaction(), count: TxGroup.MAX_TX_GROUP_SIZE+1)
        var gotExpectedException = false
        var gid:Digest?
        var thrownError1:Error?
        XCTAssertThrowsError(try TxGroup.computeGroupID(txns: txs)){
            thrownError1 = $0
        }
        XCTAssertTrue(thrownError1 is Errors, "Unexpected error type: \(type(of: thrownError1))")

        XCTAssertEqual(thrownError1 as? Errors, .illegalArgumentError("max group size is \(TxGroup.MAX_TX_GROUP_SIZE)"))
        
    }
    
    
    func testTransactionGroupEmpty()throws{
        var thrownError1:Error?
        XCTAssertThrowsError(try TxGroup.computeGroupID(txns: [])){
            thrownError1 = $0
        }
        XCTAssertTrue(thrownError1 is Errors, "Unexpected error type: \(type(of: thrownError1))")

        XCTAssertEqual(thrownError1 as? Errors, .illegalArgumentError("empty transaction list"))
        
    }
    
    
    func testTransactionGroupNull()throws{
        var thrownError1:Error?
        XCTAssertThrowsError(try TxGroup.computeGroupID(txns: [])){
            thrownError1 = $0
        }
        XCTAssertTrue(thrownError1 is Errors, "Unexpected error type: \(type(of: thrownError1))")

        XCTAssertEqual(thrownError1 as? Errors, .illegalArgumentError("empty transaction list"))
        
    }
    


    
    
    func testMakeAssetAcceptanceTxn()throws{
        var addr = try Address("BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4")
        var gh = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI="))
        var recipient = addr
        
        var firstValidRound:Int64 = 322575
        var lastValidRound: Int64 = 323575
        var assetIndex:Int64 = 1
        
        var tx = try Transaction.assetAcceptTransactionBuilder()
            .acceptingAccount(acceptingAccount: recipient)
            .fee(10)
            .firstValid(firstValidRound)
            .lastValid(lastValidRound)
            .genesisHash(gh)
            .assetIndex(assetIndex: assetIndex)
            .build()
        tx = try Account.setFeeByFeePerByte(tx: tx, suggestedFeePerByte: 10)
        var outBytes:[UInt8] = try CustomEncoder.encodeToMsgPack(tx)
        var o = try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(outBytes))
        XCTAssertEqual(o, tx)
        var stx = try TransactionTests.DEFAULT_ACCOUNT.signTransaction(tx: tx)
        var msgPack:[UInt8]  = try CustomEncoder.encodeToMsgPack(stx)
        var encodedOutBytes = try CustomEncoder.encodeToBase64(msgPack)
        
        var goldenString = "gqNzaWfEQJ7q2rOT8Sb/wB0F87ld+1zMprxVlYqbUbe+oz0WM63FctIi+K9eYFSqT26XBZ4Rr3+VTJpBE+JLKs8nctl9hgijdHhuiKRhcmN2xCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aNmZWXNCOiiZnbOAATsD6JnaMQgSGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiKibHbOAATv96NzbmTEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9pHR5cGWlYXhmZXKkeGFpZAE="
        var stxDecoded = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(msgPack))
        XCTAssertEqual(stxDecoded, stx)
        XCTAssertEqual(encodedOutBytes, goldenString)
        try TestUtil.serializeDeserializeCheck(object: stx);
    }
    

    
    func testMakeAssetTransferTxn()throws{
        var addr = try Address("BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4")
        var gh = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI="))
        var sender = addr
        var recipient = addr
        var closeAssetsTo = addr
        
        var firstValidRound:Int64 = 322575
        var lastValidRound: Int64 = 323576
        var amountToSend:Int64 = 1
        var assetIndex:Int64 = 1
        
        var tx = try Transaction.assetTransferTransactionBuilder()
            .setSender(sender)
            .assetReceiver(assetReceiver: recipient)
            .assetCloseTo(assetCloseTo: closeAssetsTo)
            .assetAmount(assetAmount: amountToSend)
            .flatFee(10)
            .firstValid(firstValidRound)
            .lastValid(lastValidRound)
            .genesisHash(gh)
            .assetIndex(assetIndex: assetIndex)
            .build()
        tx = try Account.setFeeByFeePerByte(tx: tx, suggestedFeePerByte: 10)
        var outBytes:[UInt8] = try CustomEncoder.encodeToMsgPack(tx)
        var o = try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(outBytes))
        XCTAssertEqual(o, tx)
        var stx = try TransactionTests.DEFAULT_ACCOUNT.signTransaction(tx: tx)
        var msgPack:[UInt8]  = try CustomEncoder.encodeToMsgPack(stx)
        var encodedOutBytes = try CustomEncoder.encodeToBase64(msgPack)
        
        var goldenString = "gqNzaWfEQNkEs3WdfFq6IQKJdF1n0/hbV9waLsvojy9pM1T4fvwfMNdjGQDy+LeesuQUfQVTneJD4VfMP7zKx4OUlItbrwSjdHhuiqRhYW10AaZhY2xvc2XEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9pGFyY3bEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9o2ZlZc0KvqJmds4ABOwPomdoxCBIY7UYpLPITsgQ8i1PEIHLD3HwWaesIN7GL39w5Qk6IqJsds4ABO/4o3NuZMQgCfvSdiwI+Gxa5r9t16epAd5mdddQ4H6MXHaYZH224f2kdHlwZaVheGZlcqR4YWlkAQ=="
        var stxDecoded = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(msgPack))
        XCTAssertEqual(stxDecoded, stx)
        XCTAssertEqual(encodedOutBytes, goldenString)
        try TestUtil.serializeDeserializeCheck(object: stx);
    }
    
    
    func testMakeAssetRevocationTransaction()throws{
        var addr = try Address("BH55E5RMBD4GYWXGX5W5PJ5JAHPGM5OXKDQH5DC4O2MGI7NW4H6VOE4CP4")
        var gh = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI="))
        var revoker = addr
        var revokeFrom = addr
        var receiver = addr
        
        
        var firstValidRound:Int64 = 322575
        var lastValidRound: Int64 = 323575
        var amountToSend:Int64 = 1
        var assetIndex:Int64 = 1
        var tx = try Transaction.assetClawbackTransactionBuilder()
            .setSender(revoker)
            .assetClawbackFrom(assetClawbackFrom: revoker)
            .assetReceiver(assetReceiver: receiver)
            .assetAmount(assetAmount: 1)
            .firstValid(firstValidRound)
            .lastValid(lastValidRound)
            .genesisHash(gh)
            .assetIndex(assetIndex: assetIndex).build()
        
        tx = try Account.setFeeByFeePerByte(tx: tx, suggestedFeePerByte: 10)
        var outBytes:[UInt8] = try CustomEncoder.encodeToMsgPack(tx)
        var o = try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(outBytes))
        XCTAssertEqual(o, tx)
        var stx = try TransactionTests.DEFAULT_ACCOUNT.signTransaction(tx: tx)
        var msgPack:[UInt8]  = try CustomEncoder.encodeToMsgPack(stx)
        var encodedOutBytes = try CustomEncoder.encodeToBase64(msgPack)
        
        var goldenString = "gqNzaWfEQHsgfEAmEHUxLLLR9s+Y/yq5WeoGo/jAArCbany+7ZYwExMySzAhmV7M7S8+LBtJalB4EhzEUMKmt3kNKk6+vAWjdHhuiqRhYW10AaRhcmN2xCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aRhc25kxCAJ+9J2LAj4bFrmv23Xp6kB3mZ111Dgfoxcdphkfbbh/aNmZWXNCqqiZnbOAATsD6JnaMQgSGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiKibHbOAATv96NzbmTEIAn70nYsCPhsWua/bdenqQHeZnXXUOB+jFx2mGR9tuH9pHR5cGWlYXhmZXKkeGFpZAE="
        var stxDecoded = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(msgPack))
        XCTAssertEqual(stxDecoded, stx)
        XCTAssertEqual(encodedOutBytes, goldenString)
        try TestUtil.serializeDeserializeCheck(object: stx);
    }
    

    
    
    func testEncoding()throws{
        var addr1 =  try Address("726KBOYUJJNE5J5UHCSGQGWIBZWKCBN4WYD7YVSTEXEVNFPWUIJ7TAEOPM")
        var addr2 =  try Address("42NJMHTPFVPXVSDGA6JGKUV6TARV5UZTMPFIREMLXHETRKIVW34QFSDFRE")
        var seedByte:[Int8] = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "cv8E0Ln24FSkwDgGeuXKStOTGcze5u8yldpXxgrBxumFPYdMJymqcGoxdDeyuM8t6Kxixfq0PJCyJP71uhYT7w=="))
     
        
        var account1 = try Account("unusual become trend high sea benefit ahead decide dolphin nominee grace cruise chicken all wait traffic fuel feel unhappy grace better raccoon evolve abstract toward")
        var lease = "f4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGk="
        
      var txn =  try Transaction.paymentTransactionBuilder().setSender(account1.address).fee(Account.MIN_TX_FEE_UALGOS*10).firstValid(12345).lastValid(12346).genesisHashB64("f4OxZX/x/FO5LcGBSKHWXfwtSx+j1ncoSt3SABJtkGk=").amount(amount: 5000).receiver(addr1).closeRemainderTo(addr2).leaseB64(lease: lease).build()
        var packed:[UInt8] = try CustomEncoder.encodeToMsgPack(txn)
        var txnDecoded = try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(packed))
        XCTAssertEqual(txn.lease, txnDecoded.lease)
        XCTAssertEqual(txnDecoded, txn)
        
    }

    func testTransactionWithLease()throws{
        var FROM_SK = "advice pudding treat near rule blouse same whisper inner electric quit surface sunny dismiss leader blood seat clown cost exist hospital century reform able sponsor"
        var seed = try Mnemonic.toKey(FROM_SK)
        var account = try Account(seed)
        var fromAddr =  try Address("47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU")
        var toAddr =  try Address("PNWOET7LLOWMBMLE4KOCELCX6X3D3Q4H2Q4QJASYIEOF7YIPPQBG3YQ5YI")
        var closeTo =  try Address("IDUTJEUIEVSMXTU4LGTJWZ2UE2E6TIODUKU6UW3FU3UKIQQ77RLUBBBFLA")
        var goldenString = "gqNzaWfEQOMmFSIKsZvpW0txwzhmbgQjxv6IyN7BbV5sZ2aNgFbVcrWUnqPpQQxfPhV/wdu9jzEPUU1jAujYtcNCxJ7ONgejdHhujKNhbXTNA+ilY2xvc2XEIEDpNJKIJWTLzpxZpptnVCaJ6aHDoqnqW2Wm6KRCH/xXo2ZlZc0FLKJmds0wsqNnZW6sZGV2bmV0LXYzMy4womdoxCAmCyAJoJOohot5WHIvpeVG7eftF+TYXEx4r7BFJpDt0qJsds00mqJseMQgAQIDBAECAwQBAgMEAQIDBAECAwQBAgMEAQIDBAECAwSkbm90ZcQI6gAVR0Nsv5ajcmN2xCB7bOJP61uswLFk4pwiLFf19j3Dh9Q5BIJYQRxf4Q98AqNzbmTEIOfw+E0GgR358xyNh4sRVfRnHVGhhcIAkIZn9ElYcGihpHR5cGWjcGF5"
        
        var firstValidRound:Int64 = 12466
        var lastValidRound: Int64 = 13466
        var amountToSend:Int64 = 1000
        var note = CustomEncoder.decodeByteFromBase64(string: "6gAVR0Nsv5Y=")
        var genesisID = "devnet-v33.0"
        var genesisHash = Digest(CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "JgsgCaCTqIaLeVhyL6XlRu3n7Rfk2FxMeK+wRSaQ7dI=")))
        var lease:[Int8] = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]
        
        var tx = try Transaction.paymentTransactionBuilder().setSender(fromAddr).fee(4).firstValid(firstValidRound).lastValid(lastValidRound).note(note).genesisID(genesisID).genesisHash(genesisHash).amount(amount: amountToSend).receiver(toAddr).closeRemainderTo(closeTo).lease(lease: lease).build()
        
        var outBytes:[UInt8] = try CustomEncoder.encodeToMsgPack(tx)
        var o = try CustomEncoder.decodeFrmMessagePack(obj: Transaction.self, data: Data(outBytes))
        XCTAssertEqual(o, tx)
       
        var stx = try account.signTransaction(tx: tx)
        var msgPack:[UInt8] = try CustomEncoder.encodeToMsgPack(stx)
        var encodedOutBytes = try CustomEncoder.encodeToBase64(Data(msgPack))
        var stxDecoded = try CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(msgPack))
        XCTAssertEqual(stx, stxDecoded)
        
        XCTAssertEqual(encodedOutBytes, goldenString)
        try TestUtil.serializeDeserializeCheck(object: stx);
    }
 
    
    func testEmptyByteArraysShouldBeRejected()throws{
        var fromAddr = try Address("47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU")
        var toAddr = try Address("PNWOET7LLOWMBMLE4KOCELCX6X3D3Q4H2Q4QJASYIEOF7YIPPQBG3YQ5YI")
        var empArray:[Int8] = []
        var tx = try Transaction.paymentTransactionBuilder().setSender(fromAddr).fee(4).firstValid(1).lastValid(10).amount(1).genesisHash(Digest()).receiver(toAddr).note(empArray).lease(lease: empArray).build()
        XCTAssert(tx.note == nil)
        XCTAssert(tx.lease == nil)
    }
    

    

}
