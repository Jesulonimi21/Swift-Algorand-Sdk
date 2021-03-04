
import Ed25519
import CryptoKit
import Foundation
//import MessagePack
import MessagePacker
struct TestLibrary {
    var text = "Hello, World!"
    init(){
        
    }

}





public  class me: Codable {
    var name: String;
    var asset:String? = nil
    init( _ name:String){
            self.name=name;
        }
        public func getName() ->String {
            return name;
        }
    }

class TL{
    init() throws {
        var m=me("LONIMI")
        let encoder = MessagePackEncoder()
//        let value = try! encoder.encode(m)
//        for i in 0..<value.count{
//            print(unsafeBitCast(value[i], to:Int8.self))
//        }
        var mnemonic="cactus check vocal shuffle remember regret vanish spice problem property diesel success easily napkin deposit gesture forum bag talent mechanic reunion enroll buddy about attract"
        var mnemonic2="box wear empty voyage scout cheap arrive father wagon correct thought sand planet comfort also patient vast patient tide rather young cinnamon plastic abandon model";
         
        var account =  try Account(mnemonic)
        var account1 = try Account(mnemonic2)
        var address = account.getAddress()
        var address2=account1.getAddress()
        print(address.description)
        print(address2.description)
//        Transaction.PaymentTransactionBuilder().sender(senderAddress)
//                            .amount(valueToSend).receiver(new Address(receiverAdddress)).note(note.getBytes()).suggestedParams(transactionParametersResponse).build();
        
        var genHash:[Int8] = [72,99,-75,24,-92,-77,-56,78,-56,16,-14,45,79,16,-127,-53,15,113,-16, 89, -89,-84,32, -34,-58,47,127,112,-27, 9, 58,34]
       var transactionParameterResponse=TransactionParametersResponse(fee: 0, genesisHash: genHash, genesisId: "testnet-v1.0", lastRound: 12229037)
        var tx =
            Transaction.paymentTransactionBuilder().setSender(address)
            .amount(10)
            .receiver(address)
            .suggestedParams(params: transactionParameterResponse)
//            .firstValid(12228432)
//            .genesisHash(genHash)
//            .genesisID("testnet-v1.0")
            .build()

        let val=try!MessagePackEncoder().encode(tx);
        print(Array(val))
        print(CustomEncoder.convertToInt8Array(input: Array(val)))
        print(val.count)
        
        print("-====================================")
        print("-====================================")
        print("-====================================")
        print("-====================================")
        print("-====================================")
        print("-====================================")
        print(CustomEncoder.convertToInt8Array(input: Array(val)))
        print()
        
        var sig =    account.signTransaction(tx: tx)
       
        let jsonEncoder = JSONEncoder();
        let data=try! jsonEncoder.encode(sig)
        let string=String(data:data,encoding: .utf8)
        print(string!)
        var encodedTrans:[Int8]=CustomEncoder.encodeToMsgPack(sig)
        print(encodedTrans)
       
        var HACKATHON_API_PORT="9100";
        var HACKATHON_API_ADDRESS="hackathon.algodev.network";
        var HACKATHON_API_TOKEN="ef920e2e7e002953f4b29a8af720efe8e4ecc75ff102b165e0472834b25832c1";
        var algodClient=AlgodClient(host: HACKATHON_API_ADDRESS, port: HACKATHON_API_PORT, token: HACKATHON_API_TOKEN)
      
//        
//        let queue = DispatchQueue(label: "com.knowstack.queue1")
//        queue.async {
//            print("ENTERRED ASHNC")
//          var trans =  try! algodClient.transactionParams().execute()
//            print(trans.consensusVersion)
//            print(trans.genesisId)
//            print("Finished async")
//        }
          
        
        
        
        
        
        
        print(CustomEncoder.convertBase64ToByteArray(data1: "SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI="))

       
}
  

    
    class  TtRans: Codable{
    //    {"amt":10,"fee":1000,"fv":1000,"gh":"SGO1GKSzyE7IEPItTxCByw9x8FmnrCDexi9/cOUJOiI=","lv":2000,"rcv":"r+CjG+3TdXAQ/yyWcliJ1jDFSmqBNA1ZD2aC+LlCRBs=","snd":"r+CjG+3TdXAQ/yyWcliJ1jDFSmqBNA1ZD2aC+LlCRBs=","type":"pay"}

        var amt:Int32;
        var fee:Int32;
        var fv:Int32;
        var gh:[Int8];
        var lv:Int32;
        var rcv:Address;
        var snd:Address;
        var type:String;

        enum CodingKeys:CodingKey {
            case amt
            case fee
            case fv
            case gh
            case lv
            case rcv
            case snd
            case type
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
           try! container.encode(amt, forKey: .amt)
            try! container.encode(fee, forKey: .fee)
            try! container.encode(fv, forKey: .fv)
            try! container.encode(gh, forKey: .gh)
            try!  container.encode(lv, forKey: .lv)
            try!  container.encode(rcv.bytes, forKey: .rcv)
            try!   container.encode(snd.bytes, forKey: .snd)
            try!  container.encode(type, forKey: .type)
        }
        
        init( _ amt:Int32,_ fee:Int32,_ fv:Int32,_ gh:[Int8],_ lv:Int32,_ rcv:Address,_ snd:Address,_ type:String){
               self.amt = amt;
                self.fee = fee;
                self.fv = fv;
                self.gh = gh;
                self.lv = lv;
                self.rcv = rcv;
                self.snd = snd;
                self.type = type;
           }

//           public TtRans() {
//           }
//
//           public func  getAmt()->Int {
//                return amt;
//            }
//
//            public void setAmt(int amt) {
//                this.amt = amt;
//            }
//
//            public func  getFee() ->Int{
//                return fee;
//            }
//
//            public void setFee(int fee) {
//                this.fee = fee;
//            }
//
//            public func getFv() -> Int{
//                return fv;
//            }
//
//            public void setFv(int fv) {
//                this.fv = fv;
//            }
//
//            public func getGh() -> [Int8]{
//                return gh;
//            }
//
//            public void setGh(byte[] gh) {
//                this.gh = gh;
//            }
//
//            public func getLv() ->Int {
//                return lv;
//            }
//
//            public void setLv(int lv) {
//                this.lv = lv;
//            }
//
//            public func getRcv() ->Address {
//                return rcv;
//            }
//
//            public void setRcv(Address rcv) {
//                this.rcv = rcv;
//            }
//
//            public func getSnd() ->Address {
//                return snd;
//            }
//
//            public void setSnd(Address snd) {
//                this.snd = snd;
//            }
//
//            public func getType() ->String {
//                return type;
//            }
//
//            public void setType(String type) {
//                this.type = type;
//            }
    
        }
    
    
    
//   V7QKGG7N2N2XAEH7FSLHEWEJ2YYMKSTKQE2A2WIPM2BPROKCIQNSXYAJUM
    func testAccountAndAddress() throws{
        var mnemonic="cactus check vocal shuffle remember regret vanish spice problem property diesel success easily napkin deposit gesture forum bag talent mechanic reunion enroll buddy about attract"
    
        var account =  try Account(mnemonic)
        var address = account.getAddress()
        print(address.description)
        print(account.toMnemonic())
    }
    class testClass :Codable{
        var arr:[Int16]
        init(arr:[Int16]) {
            self.arr=arr
        }
    }
    
    public static func main(){
        
    }
}
    
  

