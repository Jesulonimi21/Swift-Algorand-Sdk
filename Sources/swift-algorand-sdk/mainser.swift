////
////  File.swift
////  
////
////  Created by Jesulonimi on 2/10/21.
////
//import Ed25519
//import Foundation
//import Alamofire
////14077815
//var HACKATHON_API_PORT=9100;
//var HACKATHON_API_ADDRESS="hackathon.algodev.network";
//var HACKATHON_API_TOKEN="ef920e2e7e002953f4b29a8af720efe8e4ecc75ff102b165e0472834b25832c1";
//var algodClient=AlgodClient(host: HACKATHON_API_ADDRESS, port: HACKATHON_API_PORT, token: HACKATHON_API_TOKEN)
//let queue = DispatchQueue(label: "com.knowstack.queue1")
//var mnemonic="cactus check vocal shuffle remember regret vanish spice problem property diesel success easily napkin deposit gesture forum bag talent mechanic reunion enroll buddy about attract"
//var mnemonic2="box wear empty voyage scout cheap arrive father wagon correct thought sand planet comfort also patient vast patient tide rather young cinnamon plastic abandon model";
//var account =  try Account(mnemonic2)
//var account1 = try Account(mnemonic)
//var address = account.getAddress()
//
////algodClient.getStatus().execute(){nodeStatusResponse in
////    if(nodeStatusResponse.isSuccessful){
////        print(nodeStatusResponse.data!.lastRound)
////    }else{
////        print(nodeStatusResponse.errorDescription)
////    }
////
////}
////try! testPayment(mnemonic:mnemonic)
//
//algodClient.pendingTransactionInformation(txId: "HPS2AQU26NNVTFIJVBYYZN2P2T73AONKWCS7HPT5JUQEQMXFHMJA").execute(){ pendingTransactionResponse in
//        if(pendingTransactionResponse.isSuccessful){
//            print(pendingTransactionResponse.data!.confirmedRound)
//        }else{
//            print(pendingTransactionResponse.errorDescription!)
//            print("Errir")
//        }
//}
//dispatchMain()
//
//
//
//
//
//
//func testPayment(mnemonic:String) throws{
//
//    var account =  try Account(mnemonic)
//    var account1 = try Account(mnemonic2)
//    var address = account.getAddress()
//    var address2=account1.getAddress()
//
//
//        var trans =  algodClient.transactionParams().execute(){ paramResponse in
//            if(!(paramResponse.isSuccessful)){
//               
//            print(paramResponse.errorDescription);
//            return;
//        }
//            
//           
//           var tx = Transaction.paymentTransactionBuilder().setSender(address)
//            .amount(10)
//            .receiver(address2)
//            .note("Swift Algo sdk is cool".bytes)
//            .suggestedParams(params: paramResponse.data!).build()
//
//            var jsonencoder=JSONEncoder()
//            var txData=try! jsonencoder.encode(tx)
//            var txString=String(data:txData,encoding: .utf8)
//            print(txString)
//            
//            var signedTransaction=account.signTransaction(tx: tx)
//            var stxData=try! jsonencoder.encode(signedTransaction)
//            var stxString=String(data: stxData, encoding: .utf8)
//            print(stxString)
//            print(tx.txID())
//            var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
//            print(encodedTrans)
//            var dataToSend=Data(CustomEncoder.convertToUInt8Array(input: encodedTrans))
//    //        let headers:HTTPHeaders=["X-Algo-API-Token":HACKATHON_API_TOKEN]
//    //        AF.request("http://hackathon.algodev.network:9100/v2/transactions/",method: .post, parameters: nil, encoding: ByteEncoding(data: dataToSend), headers: headers).responseJSON(){ data in
//    //            debugPrint(data)
//    //
//    //        }
//
//            algodClient.rawTransaction().rawtxn(rawtaxn: encodedTrans).execute(){
//               response in
//                if(response.isSuccessful){
//                    print(response.data!.txId)
//                }else{
//                    print(response.errorDescription)
//                    print("Fialed")
//                }
//
//            }
//    }
//}
//
//func testCreateASA(address:Address,algodClient:AlgodClient){
//    algodClient.transactionParams().execute(){paramResponse in
//        if(!(paramResponse.isSuccessful)){
//            print(paramResponse.errorDescription);
//            return;
//        }
//        var tx = Transaction.assetCreateTransactionBuilder()
//                      .setSender(address)
//                      .setAssetTotal(assetTotal: 10000)
//                      .setAssetDecimals(assetDecimals:  0)
//                      .assetUnitName(assetUnitName: "ssawttes")
//                      .assetName(assetName:  "testssswt")
//                        .url(url: "http://nimi.com")
//                        .metadataHashUTF8(metadataHash: "16efaa3924a6fd9d3a4824799a4ac65d")
//                        .manager(manager: address)
//                        .reserve(reserve: address)
//                        .freeze(freeze: address)
//                      .defaultFrozen(defaultFrozen:  false)
//            .clawback(clawback: address)
//            .suggestedParams(params: paramResponse.data!)
//    //        .firstValid(1000)
//    //        .genesisHash([72,99,-75,24,-92,-77,-56,78,-56,16,-14,45,79,16,-127,-53,15,113,-16, 89, -89,-84,32, -34,-58,47,127,112,-27, 9, 58,34,])
//            //        .suggestedParams(params: paramResponse.data!)
//                      .build();
//
//        var txMessagePack:[Int8]=CustomEncoder.encodeToMsgPack(tx)
//        print(txMessagePack)
//
//        var jsonencoder=JSONEncoder()
//        var signedTransaction=account.signTransaction(tx: tx)
//        var stxData=try! jsonencoder.encode(signedTransaction)
//        var stxString=String(data: stxData, encoding: .utf8)
//        print(stxString)
//        print(tx.txID())
//        var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
//        print(encodedTrans)
//        var dataToSend=Data(CustomEncoder.convertToUInt8Array(input: encodedTrans))
//    //        let headers:HTTPHeaders=["X-Algo-API-Token":HACKATHON_API_TOKEN]
//    //        AF.request("http://hackathon.algodev.network:9100/v2/transactions/",method: .post, parameters: nil, encoding: ByteEncoding(data: dataToSend), headers: headers).responseJSON(){ data in
//    //            debugPrint(data)
//    //
//    //        }
//
//        print(try!account.keyPair.verify(signature: CustomEncoder.convertToUInt8Array(input: signedTransaction.sig!.bytes!), message: CustomEncoder.convertToUInt8Array(input: tx.bytesToSign())))
//        algodClient.rawTransaction().rawtxn(rawtaxn: encodedTrans).execute(){
//           response in
//            if(response.isSuccessful){
//                print(response.data!.txId)
//            }else{
//                print(response.errorDescription)
//            }
//
//        }
//
//    }
//
//}
//
//func testChangeAsaManager(){
//    algodClient.transactionParams().execute(){paramResponse in
//        if(!(paramResponse.isSuccessful)){
//            print(paramResponse.errorDescription);
//            return;
//        }
//        var tx = Transaction.assetConfigureTransactionBuilder().reserve(reserve: address).freeze(freeze: address).clawback(clawback: address).assetIndex(assetIndex: 14066442).setSender(account1.getAddress())
//        .manager(manager: account1.getAddress())
//            .suggestedParams(params: paramResponse.data!)
//                  .build();
//    //tx.assetIndex=14000663
//    var jsonencoder=JSONEncoder()
//    var txStringData=try!jsonencoder.encode(tx)
//    var txString=String(data:txStringData,encoding: .utf8)
//    print(txString)
//        var signedTransaction=account1.signTransaction(tx: tx)
//        var stxData=try! jsonencoder.encode(signedTransaction)
//        var stxString=String(data: stxData, encoding: .utf8)
//        print(stxString)
//        print(tx.txID())
//        var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(signedTransaction)
//        print(encodedTrans)
//        var dataToSend=Data(CustomEncoder.convertToUInt8Array(input: encodedTrans))
//    //        let headers:HTTPHeaders=["X-Algo-API-Token":HACKATHON_API_TOKEN]
//    //        AF.request("http://hackathon.algodev.network:9100/v2/transactions/",method: .post, parameters: nil, encoding: ByteEncoding(data: dataToSend), headers: headers).responseJSON(){ data in
//    //            debugPrint(data)
//    //
//    //        }
//
//        algodClient.rawTransaction().rawtxn(rawtaxn: encodedTrans).execute(){
//           response in
//            if(response.isSuccessful){
//                print(response.data!.txId)
//            }else{
//                print(response.errorDescription)
//            }
//
//        }
//
//    }
//
//}
//
//func testDestroyASA(){
//    algodClient.transactionParams().execute(){paramResponse in
//        if(!(paramResponse.isSuccessful)){
//            print(paramResponse.errorDescription);
//            return;
//        }
//        var tx = Transaction.assetDestroyTransactionBuilder()
//            .setSender(account1.getAddress())
//            .assetIndex(assetIndex: 14066442)
//            .suggestedParams(params: paramResponse.data!)
//                      .build();
//
//        var txMessagePack:[Int8]=CustomEncoder.encodeToMsgPack(tx)
//        print(txMessagePack)
//        print(txMessagePack.count)
//
//        var signedTrans=account1.signTransaction(tx: tx)
//        var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
//        algodClient.rawTransaction().rawtxn(rawtaxn: encodedTx).execute(){
//           response in
//            if(response.isSuccessful){
//                print(response.data!.txId)
//            }else{
//                print(response.errorDescription)
//            }
//
//        }}
//
//}
//func testAsaOptIn(){
//    
//    algodClient.transactionParams().execute(){paramResponse in
//        if(!(paramResponse.isSuccessful)){
//            print(paramResponse.errorDescription);
//            return;
//        }
//        var tx = Transaction.assetAcceptTransactionBuilder()
//            .acceptingAccount(acceptingAccount: account1.getAddress())
//            .assetIndex(assetIndex: 14077815)
//            .suggestedParams(params: paramResponse.data!)
//    //        .firstValid(1000)
//    //        .genesisHash([72,99,-75,24,-92,-77,-56,78,-56,16,-14,45,79,16,-127,-53,15,113,-16, 89, -89,-84,32, -34,-58,47,127,112,-27, 9, 58,34,])
//            .build();
//
//        var txMessagePack:[Int8]=CustomEncoder.encodeToMsgPack(tx)
//        print(txMessagePack)
//        print(txMessagePack.count)
//        var signedTrans=account1.signTransaction(tx: tx)
//        var jsonEncoder=JSONEncoder()
//        var stxBytes=try!jsonEncoder.encode(signedTrans)
//        var stxString=String(data: stxBytes, encoding: .utf8)
//        print(stxString!)
//        var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
//        algodClient.rawTransaction().rawtxn(rawtaxn: encodedTx).execute(){
//           response in
//            if(response.isSuccessful){
//                print(response.data!.txId)
//            }else{
//                print(response.errorDescription)
//            }
//
//        }}
//
//}
//
//
//func testAssetTransfer(){
//    
//    algodClient.transactionParams().execute(){paramResponse in
//        if(!(paramResponse.isSuccessful)){
//            print(paramResponse.errorDescription);
//            return;
//        }
//
//        var tx = Transaction.assetTransferTransactionBuilder().setSender(account.getAddress()).assetReceiver(assetReceiver: account1.getAddress())
//            .assetAmount(assetAmount:10).assetIndex(assetIndex:14077815).suggestedParams(params:paramResponse.data!).build();
//        
//        var txMessagePack:[Int8]=CustomEncoder.encodeToMsgPack(tx)
//        print(txMessagePack)
//        print(txMessagePack.count)
//        var signedTrans=account.signTransaction(tx: tx)
//        var jsonEncoder=JSONEncoder()
//        var stxBytes=try!jsonEncoder.encode(signedTrans)
//        var stxString=String(data: stxBytes, encoding: .utf8)
//        print(stxString!)
//        var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
//        algodClient.rawTransaction().rawtxn(rawtaxn: encodedTx).execute(){
//           response in
//            if(response.isSuccessful){
//                print(response.data!.txId)
//            }else{
//                print(response.errorDescription)
//            }
//
//        }
//    }
//
//}
//func testAssetFreeze(){
//    
//    algodClient.transactionParams().execute(){paramResponse in
//        if(!(paramResponse.isSuccessful)){
//            print(paramResponse.errorDescription);
//            return;
//        }
//
//        var tx=Transaction.assetFreezeTransactionBuilder().setSender(account.getAddress()).freezeTarget(freezeTarget:account1.getAddress())
//            .freezeState(freezeState:false).assetIndex(assetIndex: 14077815).suggestedParams(params: paramResponse.data!).build();
//        
//        var txMessagePack:[Int8]=CustomEncoder.encodeToMsgPack(tx)
//        print(txMessagePack)
//        print(txMessagePack.count)
//        var signedTrans=account.signTransaction(tx: tx)
//        var jsonEncoder=JSONEncoder()
//        var stxBytes=try!jsonEncoder.encode(signedTrans)
//        var stxString=String(data: stxBytes, encoding: .utf8)
//        print(stxString!)
//        var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
//        algodClient.rawTransaction().rawtxn(rawtaxn: encodedTx).execute(){
//           response in
//            if(response.isSuccessful){
//                print(response.data!.txId)
//            }else{
//                print(response.errorDescription)
//            }
//
//        }
//    }
//
//}
//func testAsaClawback(){
//    algodClient.transactionParams().execute(){paramResponse in
//        if(!(paramResponse.isSuccessful)){
//            print(paramResponse.errorDescription);
//            return;
//        }
//
//        var tx = Transaction.assetClawbackTransactionBuilder().setSender(account.getAddress())
//            .assetClawbackFrom(assetClawbackFrom:account1.getAddress()).assetReceiver(assetReceiver: account.getAddress()).assetAmount(assetAmount: 10)
//            .assetIndex(assetIndex:14077815).suggestedParams(params: paramResponse.data!).build();
//        var txMessagePack:[Int8]=CustomEncoder.encodeToMsgPack(tx)
//        print(txMessagePack)
//        print(txMessagePack.count)
//        var signedTrans=account.signTransaction(tx: tx)
//        var jsonEncoder=JSONEncoder()
//        var stxBytes=try!jsonEncoder.encode(signedTrans)
//        var stxString=String(data: stxBytes, encoding: .utf8)
//        print(stxString!)
//        var encodedTx:[Int8]=CustomEncoder.encodeToMsgPack(signedTrans)
//        algodClient.rawTransaction().rawtxn(rawtaxn: encodedTx).execute(){
//           response in
//            if(response.isSuccessful){
//                print(response.data!.txId)
//            }else{
//                print(response.errorDescription)
//            }
//
//        }
//    }
//}
//
//func testMultisigCreationAndTransaction(){
//    var ed25519i=Ed25519PublicKey(bytes: CustomEncoder.convertToInt8Array(input: account.keyPair.publicKey.bytes))
//    var ed25519ii=Ed25519PublicKey(bytes: CustomEncoder.convertToInt8Array(input: account1.keyPair.publicKey.bytes))
//    var multisigAddress=try! MultisigAddress(version: 1, threshold: 2, publicKeys: [ed25519ii,ed25519i]);
//    print(multisigAddress.toString())
//    algodClient.transactionParams().execute(){ paramResponse in
//        if(!(paramResponse.isSuccessful)){
//            print(paramResponse.errorDescription);
//            return;
//        }
//        
//        var tx = Transaction.paymentTransactionBuilder()
//            .setSender( try! multisigAddress.toAddress())
//            //            .suggestedParams(params: paramResponse.data!)
//              .amount(10)
//            .receiver(account.getAddress())
//    //           .firstValid(1000)
//    //                .genesisHash([72,99,-75,24,-92,-77,-56,78,-56,16,-14,45,79,16,-127,-53,15,113,-16, 89, -89,-84,32, -34,-58,47,127,112,-27, 9, 58,34,])
//            .suggestedParams(params: paramResponse.data!)
//                      .build();
//
//        var IsignedTrans = try! account.signMultisigTransaction(from: multisigAddress, tx: tx)
//        var signedTrans=try!account1.appendMultisigTransaction(from: multisigAddress, signedTx: IsignedTrans)
//        var signedTransmsgPack=CustomEncoder.convertToUInt8Array(input: CustomEncoder.encodeToMsgPack(signedTrans))
//    var int8sT:[Int8] = CustomEncoder.encodeToMsgPack(signedTrans)
//        print(int8sT)
//        print(signedTransmsgPack.count)
//    var jsonEncoder=JSONEncoder()
//    var txData=try! jsonEncoder.encode(signedTrans)
//    var txString=String(data: txData, encoding: .utf8)
//    print(txString!)
//        
//        algodClient.rawTransaction().rawtxn(rawtaxn: CustomEncoder.encodeToMsgPack(signedTrans)).execute(){
//           response in
//            if(response.isSuccessful){
//                print(response.data!.txId)
//            }else{
//                print(response.errorDescription)
//            }
//
//        }
// 
//
//    }
//
//}
