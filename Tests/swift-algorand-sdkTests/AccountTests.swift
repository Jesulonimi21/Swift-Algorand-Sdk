//
//  File.swift
//
//
//  Created by Jesulonimi on 3/4/21.
//

import Foundation
import XCTest
import swift_algorand_sdk
import Ed25519
public class AccountTests : XCTestCase{
    func testSignsTransactionE2E(){
        var REF_SIG_TXN = "82a3736967c4403f5a5cbc5cb038b0d29a53c0adf8a643822da0e41681bcab050e406fd40af20aa56a2f8c0e05d3bee8d4e8489ef13438151911b31b5ed5b660cac6bae4080507a374786e87a3616d74cd04d2a3666565cd03e8a26676ce0001a04fa26c76ce0001a437a3726376c4207d3f99e53d34ae49eb2f458761cf538408ffdaee35c70d8234166de7abe3e517a3736e64c4201bd63dc672b0bb29d42fcafa3422a4d385c0c8169bb01595babf8855cf596979a474797065a3706179"
        var REF_TX_ID = "BXSNCHKYEXB4AQXFRROUJGZ4ZWD7WL2F5D27YUPFR7ONDK5TMN5Q"
        var FROM_ADDR  = "DPLD3RTSWC5STVBPZL5DIIVE2OC4BSAWTOYBLFN2X6EFLT2ZNF4SMX64UA"
        var FROM_SK = "actress tongue harbor tray suspect odor load topple vocal avoid ignore apple lunch unknown tissue museum once switch captain place lemon sail outdoor absent creek";

        var TO_ADDR = "PU7ZTZJ5GSXET2ZPIWDWDT2TQQEP7WXOGXDQ3ARUCZW6PK7D4ULSE6NYCE"
        
        var tx = try! Transaction.paymentTransactionBuilder()
            .setSender(Address(FROM_ADDR))
            .receiver(Address(TO_ADDR))
            .flatFee(Account.MIN_TX_FEE_UALGOS)
            .amount(amount: 1234)
            .firstValid(106575)
            .lastValid(107575)
            .genesisHash(Digest())
            .build()
        
        var seed = try! Mnemonic.toKey(FROM_SK)
        var account  = try! Account(seed)
        XCTAssertEqual(try! Address(CustomEncoder.convertToInt8Array(input: account.keyPair.publicKey.bytes)).description, FROM_ADDR)
        
        XCTAssertEqual(account.address.description, FROM_ADDR)
        
        var stx = account.signTransaction(tx: tx)
     
        var stxBytes:[Int8] = CustomEncoder.encodeToMsgPack(stx)
        var signedTxHex = CustomEncoder.encodeToHexString(bytes:stxBytes)
        
        XCTAssertEqual(signedTxHex, REF_SIG_TXN)
        var txID =  stx.transactionID
        XCTAssertEqual(txID, REF_TX_ID)
        
    }
    
    func testSignTransactionZeroValE2E(){
        var REF_SIG_TXN = "82a3736967c440fc12c24dc9d7c48ff0bfb3464c3f4d429088ffe98353a844ba833fd32aaef577e78b49e2674f9998fa5ddfc49db52d8e0c258cafdb5d55ab73edd6678d4b230ea374786e86a3616d74cd04d2a3666565cd03e8a26c76ce0001a437a3726376c4207d3f99e53d34ae49eb2f458761cf538408ffdaee35c70d8234166de7abe3e517a3736e64c4201bd63dc672b0bb29d42fcafa3422a4d385c0c8169bb01595babf8855cf596979a474797065a3706179"
        var REF_TX_ID = "LH7ZXC6OO2LMDSDUIGA42WTILX7TX2K6HE4JVHGAR2UFYU6JZQOA"
        var FROM_ADDR  = "DPLD3RTSWC5STVBPZL5DIIVE2OC4BSAWTOYBLFN2X6EFLT2ZNF4SMX64UA"
        var FROM_SK = "actress tongue harbor tray suspect odor load topple vocal avoid ignore apple lunch unknown tissue museum once switch captain place lemon sail outdoor absent creek"
        var TO_ADDR = "PU7ZTZJ5GSXET2ZPIWDWDT2TQQEP7WXOGXDQ3ARUCZW6PK7D4ULSE6NYCE"
        
        var tx = try! Transaction.paymentTransactionBuilder()
            .setSender(Address(FROM_ADDR))
            .receiver(Address(TO_ADDR))
            .flatFee(Account.MIN_TX_FEE_UALGOS)
            .amount(amount: 1234)
            .firstValid(0)
            .lastValid(107575)
            .genesisHash(Digest())
            .build()
        
        var seed = try! Mnemonic.toKey(FROM_SK)
        var account  = try! Account(seed)
        XCTAssertEqual(try! Address(CustomEncoder.convertToInt8Array(input: account.keyPair.publicKey.bytes)).description, FROM_ADDR)
        
        XCTAssertEqual(account.address.description, FROM_ADDR)
        
        var stx = account.signTransaction(tx: tx)
     
        var stxBytes:[Int8] = CustomEncoder.encodeToMsgPack(stx)
        var signedTxHex = CustomEncoder.encodeToHexString(bytes:stxBytes)
        
        XCTAssertEqual(signedTxHex, REF_SIG_TXN)
        var txID =  stx.transactionID
        XCTAssertEqual(txID, REF_TX_ID)
        
    }
    
    
     func testKeyGen(){
        for i in 0...100{
            var account = try! Account()
            XCTAssert(account.keyPair.publicKey.bytes.count>0)
            XCTAssert(account.address.bytes != nil)
            XCTAssertEqual(CustomEncoder.convertToInt8Array(input: account.keyPair.publicKey.bytes),account.address.bytes)
      
        }
    }

    func testToMnemonic(){
        var FROM_SK = "actress tongue harbor tray suspect odor load topple vocal avoid ignore apple lunch unknown tissue museum once switch captain place lemon sail outdoor absent creek"
        var seed = try! Mnemonic.toKey(FROM_SK)
        var account = try! Account(seed)
        XCTAssertEqual(account.toMnemonic(), FROM_SK)
        
    }

    private func makeTestMsigAddr()->MultisigAddress{
        var one = try!  Address("DN7MBMCL5JQ3PFUQS7TMX5AH4EEKOBJVDUF4TCV6WERATKFLQF4MQUPZTA")
        var two = try! Address("BFRTECKTOOE7A5LHCF3TTEOH2A7BW46IYT2SX5VP6ANKEXHZYJY77SJTVM")
        var three =  try! Address("47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU")
        return try! MultisigAddress(version:1,  threshold:2,publicKeys:[
            Ed25519PublicKey(bytes: one.getBytes()),
            Ed25519PublicKey(bytes: two.getBytes()),
            Ed25519PublicKey(bytes: three.getBytes())
        ])
    }

    
    func testSignMultisigTransaction(){
        var addr = makeTestMsigAddr()
        var tx = try! Transaction.paymentTransactionBuilder().setSender(addr.toAddress()).flatFee(217000).firstValid(972508).lastValid(973508).noteB64(note: "tFF5Ofz60nE=").amount(5000).receiver(Address("DN7MBMCL5JQ3PFUQS7TMX5AH4EEKOBJVDUF4TCV6WERATKFLQF4MQUPZTA")).genesisID("testnet-v31.0").genesisHash(Digest()).build()
            
        var seed = try! Mnemonic.toKey("auction inquiry lava second expand liberty glass involve ginger illness length room item discover ahead table doctor term tackle cement bonus profit right above catch")
        var account = try! Account(seed)
        var stx = try! account.signMultisigTransaction(from: addr, tx: tx)
       
        
        var enc:[Int8] = CustomEncoder.encodeToMsgPack(stx)
        XCTAssertEqual(account.signMultisigTransactionBytes(from: addr, tx: tx), enc)
        
        var golden:[Int8] = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAdvZ3y9GsInBPutdwKc7Jy+an13CcjSV1lcvRAYQKYOxXwfgT5B/mK14R57ueYJTYyoDO8zBY6kQmBalWkm95AIGicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxgaJwa8Qg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGjdGhyAqF2AaN0eG6Jo2FtdM0TiKNmZWXOAANPqKJmds4ADtbco2dlbq10ZXN0bmV0LXYzMS4womx2zgAO2sSkbm90ZcQItFF5Ofz60nGjcmN2xCAbfsCwS+pht5aQl+bL9AfhCKcFNR0LyYq+sSIJqKuBeKNzbmTEII2StImQAXOgTfpDWaNmamr86ixCoF3Zwfc+66VHgDfppHR5cGWjcGF5")
            )
        XCTAssertEqual(enc,golden)
    }
    
    public func testAppendMultisigTransaction(){
        var addr = makeTestMsigAddr()
        var firstTxBytes = CustomEncoder.decodeByteFromBase64(string: "gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAdvZ3y9GsInBPutdwKc7Jy+an13CcjSV1lcvRAYQKYOxXwfgT5B/mK14R57ueYJTYyoDO8zBY6kQmBalWkm95AIGicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxgaJwa8Qg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGjdGhyAqF2AaN0eG6Jo2FtdM0TiKNmZWXOAANPqKJmds4ADtbco2dlbq10ZXN0bmV0LXYzMS4womx2zgAO2sSkbm90ZcQItFF5Ofz60nGjcmN2xCAbfsCwS+pht5aQl+bL9AfhCKcFNR0LyYq+sSIJqKuBeKNzbmTEII2StImQAXOgTfpDWaNmamr86ixCoF3Zwfc+66VHgDfppHR5cGWjcGF5")
        
        var seed = try! Mnemonic.toKey("since during average anxiety protect cherry club long lawsuit loan expand embark forum theory winter park twenty ball kangaroo cram burst board host ability left")
        var account = try! Account(seed)
        var appended = account.appendMultisigTransactionBytes(from: addr, txBytes: CustomEncoder.convertToInt8Array(input: firstTxBytes))
    
        
        
        var expected = CustomEncoder.decodeByteFromBase64(string: "gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAdvZ3y9GsInBPutdwKc7Jy+an13CcjSV1lcvRAYQKYOxXwfgT5B/mK14R57ueYJTYyoDO8zBY6kQmBalWkm95AIKicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxoXPEQE4cdVDpoVoVVokXRGz6O9G3Ojljd+kd6d2AahXLPGDPtT/QA9DI1rB4w8cEDTy7gd5Padkn5EZC2pjzGh0McAeBonBrxCDn8PhNBoEd+fMcjYeLEVX0Zx1RoYXCAJCGZ/RJWHBooaN0aHICoXYBo3R4bomjYW10zROIo2ZlZc4AA0+oomZ2zgAO1tyjZ2VurXRlc3RuZXQtdjMxLjCibHbOAA7axKRub3RlxAi0UXk5/PrScaNyY3bEIBt+wLBL6mG3lpCX5sv0B+EIpwU1HQvJir6xIgmoq4F4o3NuZMQgjZK0iZABc6BN+kNZo2ZqavzqLEKgXdnB9z7rpUeAN+mkdHlwZaNwYXk=")
        
        XCTAssertEqual(appended, CustomEncoder.convertToInt8Array(input: expected))
    }
    
    func testSignMultisigKeyRegTransaction(){
        var addr = makeTestMsigAddr()
    
        var encKeyRegTx = CustomEncoder.decodeByteFromBase64(string: "gaN0eG6Jo2ZlZc4AA8jAomZ2zgAO+dqibHbOAA79wqZzZWxrZXnEIDISKyvWPdxTMZYXpapTxLHCb+PcyvKNNiK1aXehQFyGo3NuZMQgjZK0iZABc6BN+kNZo2ZqavzqLEKgXdnB9z7rpUeAN+mkdHlwZaZrZXlyZWemdm90ZWtkzScQp3ZvdGVrZXnEIHAb1/uRKwezCBH/KB2f7pVj5YAuICaJIxklj3f6kx6Ip3ZvdGVsc3TOAA9CQA==")
        
        var wrappedTx = CustomEncoder.decodeFrmMessagePack(obj: SignedTransaction.self, data: Data(encKeyRegTx))
        var seed = try! Mnemonic.toKey("auction inquiry lava second expand liberty glass involve ginger illness length room item discover ahead table doctor term tackle cement bonus profit right above catch")
        var account = try! Account(seed)
        var stx = try! account.signMultisigTransaction(from: addr, tx: wrappedTx.tx!)
        var enc:[Int8] = CustomEncoder.encodeToMsgPack(stx)
        var golden = CustomEncoder.decodeByteFromBase64(string: "gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAujReoxR7FeTUTqgOn+rS20XOF3ENA+JrSgZ5yvrDPg3NQAzQzUXddB0PVvPRn490oVSQaHEIY05EDJXVBFPJD4GicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxgaJwa8Qg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGjdGhyAqF2AaN0eG6Jo2ZlZc4AA8jAomZ2zgAO+dqibHbOAA79wqZzZWxrZXnEIDISKyvWPdxTMZYXpapTxLHCb+PcyvKNNiK1aXehQFyGo3NuZMQgjZK0iZABc6BN+kNZo2ZqavzqLEKgXdnB9z7rpUeAN+mkdHlwZaZrZXlyZWemdm90ZWtkzScQp3ZvdGVrZXnEIHAb1/uRKwezCBH/KB2f7pVj5YAuICaJIxklj3f6kx6Ip3ZvdGVsc3TOAA9CQA==")
     
        XCTAssertEqual(enc, CustomEncoder.convertToInt8Array(input: golden))
    
    }

   
    
    func testAppendMultisigKeyRegTransaction(){
        var addr = makeTestMsigAddr()
        var firstTxBytes = CustomEncoder.convertBase64ToByteArray(data1: "gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAujReoxR7FeTUTqgOn+rS20XOF3ENA+JrSgZ5yvrDPg3NQAzQzUXddB0PVvPRn490oVSQaHEIY05EDJXVBFPJD4GicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxgaJwa8Qg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGjdGhyAqF2AaN0eG6Jo2ZlZc4AA8jAomZ2zgAO+dqibHbOAA79wqZzZWxrZXnEIDISKyvWPdxTMZYXpapTxLHCb+PcyvKNNiK1aXehQFyGo3NuZMQgjZK0iZABc6BN+kNZo2ZqavzqLEKgXdnB9z7rpUeAN+mkdHlwZaZrZXlyZWemdm90ZWtkzScQp3ZvdGVrZXnEIHAb1/uRKwezCBH/KB2f7pVj5YAuICaJIxklj3f6kx6Ip3ZvdGVsc3TOAA9CQA==")
        
        var seed = try! Mnemonic.toKey("advice pudding treat near rule blouse same whisper inner electric quit surface sunny dismiss leader blood seat clown cost exist hospital century reform able sponsor")
        var account = try! Account(seed)
        
        var appended = account.appendMultisigTransactionBytes(from: addr, txBytes: CustomEncoder.convertToInt8Array(input: firstTxBytes))
        
        var expected = CustomEncoder.convertBase64ToByteArray(data1: "gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAujReoxR7FeTUTqgOn+rS20XOF3ENA+JrSgZ5yvrDPg3NQAzQzUXddB0PVvPRn490oVSQaHEIY05EDJXVBFPJD4GicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxgqJwa8Qg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGhc8RArIVZWayeobzKSv+zpJJmbrjsglY5J09/1KU37T5cSl595mMotqO7a2Hmz0XaRxoS6pVhsc2YSkMiU/YhHJCcA6N0aHICoXYBo3R4bomjZmVlzgADyMCiZnbOAA752qJsds4ADv3CpnNlbGtlecQgMhIrK9Y93FMxlhelqlPEscJv49zK8o02IrVpd6FAXIajc25kxCCNkrSJkAFzoE36Q1mjZmpq/OosQqBd2cH3PuulR4A36aR0eXBlpmtleXJlZ6Z2b3Rla2TNJxCndm90ZWtlecQgcBvX+5ErB7MIEf8oHZ/ulWPlgC4gJokjGSWPd/qTHoindm90ZWxzdM4AD0JA")
        XCTAssertEqual(appended, CustomEncoder.convertToInt8Array(input: expected))
    }
    
    func testMergeMultisigTransaction (){
        var firstAndThird = CustomEncoder.convertBase64ToByteArray(data1: "gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAujReoxR7FeTUTqgOn+rS20XOF3ENA+JrSgZ5yvrDPg3NQAzQzUXddB0PVvPRn490oVSQaHEIY05EDJXVBFPJD4GicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxgqJwa8Qg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGhc8RArIVZWayeobzKSv+zpJJmbrjsglY5J09/1KU37T5cSl595mMotqO7a2Hmz0XaRxoS6pVhsc2YSkMiU/YhHJCcA6N0aHICoXYBo3R4bomjZmVlzgADyMCiZnbOAA752qJsds4ADv3CpnNlbGtlecQgMhIrK9Y93FMxlhelqlPEscJv49zK8o02IrVpd6FAXIajc25kxCCNkrSJkAFzoE36Q1mjZmpq/OosQqBd2cH3PuulR4A36aR0eXBlpmtleXJlZ6Z2b3Rla2TNJxCndm90ZWtlecQgcBvX+5ErB7MIEf8oHZ/ulWPlgC4gJokjGSWPd/qTHoindm90ZWxzdM4AD0JA")
        
        var secondAndThird = CustomEncoder.convertBase64ToByteArray(data1: "gqRtc2lng6ZzdWJzaWeTgaJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXiConBrxCAJYzIJU3OJ8HVnEXc5kcfQPhtzyMT1K/av8BqiXPnCcaFzxEC/jqaH0Dvo3Fa0ZVXsQAP8M5UL9+JxzWipDnA1wmApqllyuZHkZNwG0eSY+LDKMBoB2WaYcJNWypJi4l1f6aIPgqJwa8Qg5/D4TQaBHfnzHI2HixFV9GcdUaGFwgCQhmf0SVhwaKGhc8RArIVZWayeobzKSv+zpJJmbrjsglY5J09/1KU37T5cSl595mMotqO7a2Hmz0XaRxoS6pVhsc2YSkMiU/YhHJCcA6N0aHICoXYBo3R4bomjZmVlzgADyMCiZnbOAA752qJsds4ADv3CpnNlbGtlecQgMhIrK9Y93FMxlhelqlPEscJv49zK8o02IrVpd6FAXIajc25kxCCNkrSJkAFzoE36Q1mjZmpq/OosQqBd2cH3PuulR4A36aR0eXBlpmtleXJlZ6Z2b3Rla2TNJxCndm90ZWtlecQgcBvX+5ErB7MIEf8oHZ/ulWPlgC4gJokjGSWPd/qTHoindm90ZWxzdM4AD0JA")
        
        var expected = CustomEncoder.convertBase64ToByteArray(data1: "gqRtc2lng6ZzdWJzaWeTgqJwa8QgG37AsEvqYbeWkJfmy/QH4QinBTUdC8mKvrEiCairgXihc8RAujReoxR7FeTUTqgOn+rS20XOF3ENA+JrSgZ5yvrDPg3NQAzQzUXddB0PVvPRn490oVSQaHEIY05EDJXVBFPJD4KicGvEIAljMglTc4nwdWcRdzmRx9A+G3PIxPUr9q/wGqJc+cJxoXPEQL+OpofQO+jcVrRlVexAA/wzlQv34nHNaKkOcDXCYCmqWXK5keRk3AbR5Jj4sMowGgHZZphwk1bKkmLiXV/pog+ConBrxCDn8PhNBoEd+fMcjYeLEVX0Zx1RoYXCAJCGZ/RJWHBooaFzxECshVlZrJ6hvMpK/7OkkmZuuOyCVjknT3/UpTftPlxKXn3mYyi2o7trYebPRdpHGhLqlWGxzZhKQyJT9iEckJwDo3RocgKhdgGjdHhuiaNmZWXOAAPIwKJmds4ADvnaomx2zgAO/cKmc2Vsa2V5xCAyEisr1j3cUzGWF6WqU8Sxwm/j3MryjTYitWl3oUBchqNzbmTEII2StImQAXOgTfpDWaNmamr86ixCoF3Zwfc+66VHgDfppHR5cGWma2V5cmVnpnZvdGVrZM0nEKd2b3Rla2V5xCBwG9f7kSsHswgR/ygdn+6VY+WALiAmiSMZJY93+pMeiKd2b3RlbHN0zgAPQkA=")
        var a = Account.mergeMultisigTransactionBytes(txsBytes:[CustomEncoder.convertToInt8Array(input: firstAndThird) ,CustomEncoder.convertToInt8Array(input: secondAndThird) ])
    
        var b = Account.mergeMultisigTransactionBytes(txsBytes:[CustomEncoder.convertToInt8Array(input: secondAndThird), CustomEncoder.convertToInt8Array(input: firstAndThird)]);
        XCTAssertEqual(a, b)
        XCTAssertEqual(a, CustomEncoder.convertToInt8Array(input: expected) )
        
        
    }
    func testSignBytes(){
        var bytes: [UInt8] = [1,2,3,4]
        var mnemonic="cactus check vocal shuffle remember regret vanish spice problem property diesel success easily napkin deposit gesture forum bag talent mechanic reunion enroll buddy about attract"
        var account = try! Account(mnemonic)
        var signedTx = account.keyPair.sign(bytes);
        var isVerified = try! account.keyPair.verify(signature: signedTx, message: bytes)
        XCTAssertEqual( isVerified, true)
    }
    
    
    func testTransactionSignatureVerification(){
        var mnemonic="cactus check vocal shuffle remember regret vanish spice problem property diesel success easily napkin deposit gesture forum bag talent mechanic reunion enroll buddy about attract"
                    var address = try! Address("VJQG6EJPZDAWFYLFF5XE3OMRQEK6RFFYSBVJOGXBH63ZQZ3QRRIUVIB7MY")
                   var tx = Transaction.paymentTransactionBuilder().setSender(address)
                    .amount(10)
                    .receiver(address)
                    .note("Swift Algo sdk is cool".bytes)
                   .build()
        var account = try! Account(mnemonic)
        var stxBytes:[UInt8] = account.keyPair.sign(CustomEncoder.encodeToMsgPack(tx))
        var isVerified = try! account.keyPair.verify(signature: stxBytes, message: CustomEncoder.encodeToMsgPack(tx))
      
        AlgoLogic.loadLangSpec()
        XCTAssertEqual( isVerified, true)
            
        
    }
    func testLogicsigTransaction(){
     var from = try! Address("47YPQTIGQEO7T4Y4RWDYWEKV6RTR2UNBQXBABEEGM72ESWDQNCQ52OPASU")
        var to = try! Address("PNWOET7LLOWMBMLE4KOCELCX6X3D3Q4H2Q4QJASYIEOF7YIPPQBG3YQ5YI")
        var mn = "advice pudding treat near rule blouse same whisper inner electric quit surface sunny dismiss leader blood seat clown cost exist hospital century reform able sponsor"
        var account = try! Account(mn)
        

        var fee:Int64 = 1000
        var amount:Int64 = 2000
        var genesisID = "devnet-v1.0"
     
        var genesisHash = Digest(CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "sC3P7e2SdbqKJK0tbiCdK9tdSpbe6XeCGKdoNzmlj0E=")))
    
        var firstRound:Int64 = 2063137
        var note = CustomEncoder.convertBase64ToByteArray(data1: "8xMCTuLQ810=")
      
        var tx = Transaction
            .paymentTransactionBuilder().setSender(from).flatFee(fee).firstValid(firstRound).lastValid(firstRound+1000).note(note).genesisID(genesisID).genesisHash(genesisHash).amount(amount).receiver(to).build()
        
        var goldenTx = "gqRsc2lng6NhcmeSxAMxMjPEAzQ1NqFsxAUBIAEBIqNzaWfEQE6HXaI5K0lcq50o/y3bWOYsyw9TLi/oorZB4xaNdn1Z14351u2f6JTON478fl+JhIP4HNRRAIh/I8EWXBPpJQ2jdHhuiqNhbXTNB9CjZmVlzQPoomZ2zgAfeyGjZ2Vuq2Rldm5ldC12MS4womdoxCCwLc/t7ZJ1uookrS1uIJ0r211Klt7pd4IYp2g3OaWPQaJsds4AH38JpG5vdGXECPMTAk7i0PNdo3JjdsQge2ziT+tbrMCxZOKcIixX9fY9w4fUOQSCWEEcX+EPfAKjc25kxCDn8PhNBoEd+fMcjYeLEVX0Zx1RoYXCAJCGZ/RJWHBooaR0eXBlo3BheQ=="

        var program:[Int8] = [
            1, 32, 1, 1, 34, 
        ]

       var args:[[Int8]] = Array()
        var arg1:[Int8] = [49, 50, 51]
        var arg2:[Int8] = [52, 53, 54]
        args.append(arg1);
        args.append(arg2);

        var lsig:LogicsigSignature = LogicsigSignature(logicsig: program, args: args)
  
        lsig = try! account.signLogicsig(lsig:lsig)
        var stx = Account.signLogicsigTransaction(lsig: lsig, tx: tx)
        var messagePack:[Int8] = CustomEncoder.encodeToMsgPack(stx)
      
       
        XCTAssertEqual(CustomEncoder.encodeToBase64(messagePack),goldenTx)

    }
    
    
    func testTealSign(){
        var data = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "Ux8jntyBJQarjKGF8A=="))
        var seed = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "5Pf7eGMA52qfMT4R4/vYCt7con/7U3yejkdXkrcb26Q="))
        var prog = CustomEncoder.convertToInt8Array(input: CustomEncoder.decodeByteFromBase64(string: "ASABASI="))
        var addr = try! Address("6Z3C3LDVWGMX23BMSYMANACQOSINPFIRF77H7N3AWJZYV6OH6GWTJKVMXY")
        var acc = try! Account(seed)
        var sig1 = acc.tealSign(data:data,contractAddress:addr)
        var sig2 = acc.tealSignFromProgram(data: data, program: prog)
        XCTAssertEqual(sig1.bytes, sig2.bytes)
        
        var prefix:[Int8] = [80, 114, 111, 103, 68, 97, 116, 97, ]
        var  rawAddr:[Int8] = addr.getBytes();
        var message:[Int8] = Array()
        message.append(contentsOf: prefix)
        message.append(contentsOf: rawAddr)
        message.append(contentsOf: data)
    
        
        let publicKey = try! PublicKey(CustomEncoder.convertToUInt8Array(input: acc.address.getBytes()))
        
        var isVerified = try! publicKey.verify(signature: CustomEncoder.convertToUInt8Array(input: sig1.bytes!), message: CustomEncoder.convertToUInt8Array(input: message))
        XCTAssert(isVerified==true)
            
    }
    
    static var allTests = [
        ("testSignBytes", testSignBytes),
        ("testTransactionSignatureVerification",testTransactionSignatureVerification)
    ]

}



