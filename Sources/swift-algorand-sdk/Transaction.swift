//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/4/21.

import Foundation


//extension Transaction.onCompletion:Codable{
//      enum Key: CodingKey {
//          case rawValue
//      }
//
//      enum CodingError: Error {
//          case unknownValue
//      }
//
//      init(from decoder: Decoder) throws {
//          let container = try decoder.container(keyedBy: Key.self)
//          let rawValue = try container.decode(String.self, forKey: .rawValue)
//          switch rawValue {
//          case "noop":
//              self = .NoOpOC
//          case "optin":
//              self = .OptInOC
//          case "closeout":
//              self = .CloseOutOC
//          case "clearstate":
//              self = .ClearStateOC
//          case "update":
//              self = .UpdateApplicationOC
//          case "delete":
//              self = .DeleteApplicationOC
//
//
//          default:
//              throw CodingError.unknownValue
//          }
//      }
//
//    func encode(to encoder: Encoder) throws {
//          var container = encoder.container(keyedBy: Key.self)
//          switch self {
//          case .NoOpOC:
//              try container.encode("noop", forKey: .rawValue)
//          case .OptInOC:
//              try container.encode("optin", forKey: .rawValue)
//          case .CloseOutOC:
//              try container.encode("closeout", forKey: .rawValue)
//          case .ClearStateOC:
//              try container.encode("clearstate", forKey: .rawValue)
//          case .UpdateApplicationOC:
//              try container.encode("update", forKey: .rawValue)
//          case .DeleteApplicationOC:
//              try container.encode("delete", forKey: .rawValue)
//          }
//      }
//
//
//
//}

extension Transaction.type:Codable{
    enum Key:String, CodingKey{
        case rawValue
    }
    enum CodingError: Error{
        case unknownValue
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        switch rawValue {
        case "":
            self = .Default
        case "Payment":
            self = .Payment
        case "keyreg" :
            self = .KeyRegistration
        case "acfg":
            self = .AssetConfig
        case "axfer":
            self = .AssetTransfer
            
        case "afrz":
            self = .AssetFreeze
        
        case "appl":
            self = .ApplicationCall
        default:
            throw CodingError.unknownValue
        }
    }
    
  func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .Default:
            try container.encode("", forKey: .rawValue)
        case .Payment:
            try container.encode("Payment",forKey: .rawValue)
        case .KeyRegistration:
            try container.encode("keyreg",forKey: .rawValue)
        case .AssetConfig:
            try container.encode("acfg",forKey: .rawValue)
        case .AssetTransfer:
            try container.encode("axfer",forKey: .rawValue)
        case .AssetFreeze:
            try container.encode("afrz",forKey: .rawValue)
            
        case .ApplicationCall:
            try container.encode("appl",forKey: .rawValue)
        }
    }
}


public class Transaction : Codable,Equatable{
 public   enum onCompletion: String,Codable {
        case  NoOpOC="noop"
        case  OptInOC="optin"
        case CloseOutOC="closeout"
        case  ClearStateOC="clearstate"
        case  UpdateApplicationOC="update"
         case DeleteApplicationOC="delete"
        
        enum Key: CodingKey {
            case rawValue
        }
        
        enum CodingError: Error {
            case unknownValue
        }
        
    public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(Int.self)
            switch rawValue {
            case 0:
                self = .NoOpOC
            case 1 :
                self = .OptInOC
            case 2:
                self = .CloseOutOC
            case 3:
                self = .ClearStateOC
            case 4:
                self = .UpdateApplicationOC
            case 5:
                self = .DeleteApplicationOC
         
           
            default:
                throw CodingError.unknownValue
            }
        }
        
    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .NoOpOC:
                try container.encode(0)
            case .OptInOC:
                try container.encode(1)
            case .CloseOutOC:
                try container.encode(2)
            case .ClearStateOC:
                try container.encode(3)
            case .UpdateApplicationOC:
                try container.encode(4)
            case .DeleteApplicationOC:
                try container.encode(5)
            }
        }
    }
    
    enum type: String {
       case Default=""
       case Payment="pay"
       case KeyRegistration="keyreg"
       case AssetConfig="acfg"
       case AssetTransfer="axfer"
       case AssetFreeze="afrz"
       case ApplicationCall="appl"
    }
   
    
    
     
        
    public var type:String;
     
    var TX_SIGN_PREFIX:[Int8]=[84,88]
  public  var assetParams:AssetParams?=nil
    public  var selectionPK:VRFPublicKey?=nil
   public var foreignApps:[Int64]?=nil
   public var applicationArgs:[[Int8]]?=nil
   public var votePK:ParticipationPublicKey?=nil
   public var sender:Address?;
   public var localStateSchema:StateSchema?=nil
   public var globalStateSchema: StateSchema?=nil
   public var fee:Int64?=nil;
   public var firstValid:Int64?=nil;
   public var lastValid:Int64?=nil;
   public var note:[Int8]?=nil;
   public var genesisID: String?=nil;
   public var genesisHash:Digest?=Digest();
   public var  group:Digest?=nil;
   public var lease:[Int8]?=nil;
   public var rekeyTo:Address?=nil;
   public var amount:Int64?=nil;
   public var receiver:Address?=nil;
   public var closeRemainderTo:Address?=nil;
   public var voteFirst:Int64?=nil;
   public var voteLast:Int64?=nil;
   public var voteKeyDilution:Int64?=nil;
   public var assetIndex:Int64?=nil;
   public var  xferAsset:Int64?=nil;
   public var assetAmount:Int64?=nil;
   public var assetSender:Address?=nil;
   public var assetReceiver:Address?=nil;
   public var assetCloseTo:Address?=nil;
   public var freezeTarget:Address?=nil;
   public var assetFreezeID:Int64?=nil;
   public var freezeState:Bool?=nil;
   public var onCompletion: onCompletion?=nil;
   public var  accounts:[Address]?=nil;
   public var foreignAssets:[Int64]?=nil;

   public var applicationId:Int64?=nil;

    public var clearStateProgram:TEALProgram?
    public var approvalProgram:TEALProgram?
    public var innerTxns: [PendingTransactionResponse]?=nil
    
    public var logs: [[Int8]]?=nil

    
   
       
      
         convenience   init(_ fromAddr:Address, _ toAddr:Address,  _ fee:Int64, _ amount:Int64,_ firstRound:Int64,  _ lastRound:Int64) {
                self.init(fromAddr, fee, firstRound, lastRound, [], amount, toAddr, "",  Digest());
        }

        /** @deprecated */
//        @Deprecated
    convenience init(_ fromAddr:Address, _ toAddr:Address, _ fee:Int64, _ amount:Int64, _ firstRound:Int64, _ lastRound:Int64, _ genesisID:String, _ genesisHash:Digest) {
        self.init(fromAddr, fee, firstRound, lastRound, [], amount, toAddr, genesisID, genesisHash);
        }

        /** @deprecated */
        
    convenience init (_ fromAddr: Address, _ toAddr: Address, _ amount:Int64, _ firstRound:Int64, _ lastRound: Int64,  genesisID: String, _ genesisHash:Digest) {
        self.init(fromAddr, Account.MIN_TX_FEE_UALGOS,firstRound, lastRound, [], amount, toAddr, genesisID, genesisHash);
        }

      
    
    convenience init(_ sender:Address, _ fee:Int64, _ firstValid: Int64, _ lastValid:Int64,_ note:[Int8], _ amount:Int64, _ receiver: Address, _ genesisID:String, _ genesisHash:Digest) {
        self.init(sender, fee, firstValid, lastValid, note, genesisID, genesisHash, amount, receiver,  Address());
        }
    
    
    init( _ sender: Address, _ fee: Int64, _ firstValid: Int64, _ lastValid: Int64, _ note:[Int8], _ genesisID: String, _ genesisHash: Digest,
         _ amount: Int64, _ receiver: Address, _ closeRemainderTo: Address) {
        self.type = Transaction.type.Default.rawValue;
           self.sender =  Address();
           self.fee = Account.MIN_TX_FEE_UALGOS;
           self.firstValid = 0;
           self.lastValid = 0;
           self.genesisID = "";
           self.genesisHash =  nil;
           self.group =  nil;
           self.rekeyTo = nil;
           self.amount = nil;
           self.receiver = nil;
           self.closeRemainderTo =  Address();
           self.voteFirst = nil;
           self.voteLast = nil;
           self.voteKeyDilution = 0;
           self.assetIndex = nil;
            self.xferAsset = nil;
           self.assetAmount = nil;
           self.assetSender =  nil;
           self.assetReceiver = nil;
           self.assetCloseTo =  nil;
           self.freezeTarget =  Address();
           self.assetFreezeID = 0;
           self.freezeState = false;
          self.applicationArgs = [];
        self.onCompletion = Transaction.onCompletion.NoOpOC;
           self.accounts = [];
           self.foreignAssets = []
           self.applicationId = 0;

        self.type = Transaction.type.Payment.rawValue;
           if (sender != nil) {
               self.sender = sender;
           }

           if (firstValid != nil) {
               self.firstValid = firstValid;
           }

           if (lastValid != nil) {
               self.lastValid = lastValid;
           }
        if (genesisID != nil) {
               self.genesisID = genesisID;
           }

           if (genesisHash != nil) {
               self.genesisHash = genesisHash;
           }

           if (amount != nil) {
               self.amount = amount;
           }

           if (receiver != nil) {
               self.receiver = receiver;
           }

           if (closeRemainderTo != nil) {
               self.closeRemainderTo = closeRemainderTo;
           }

       }

    public func bytesToSign() -> [Int8] {
        var encodedTx:[Int8] = CustomEncoder.encodeToMsgPack(self);
        var prefixEncodedTx:[Int8] = Array(repeating: 0, count: encodedTx.count+2)
        for i in 0..<TX_SIGN_PREFIX.count{
            prefixEncodedTx[i]=TX_SIGN_PREFIX[i]
        }
        var counter=0;
        for i in TX_SIGN_PREFIX.count..<prefixEncodedTx.count{
            prefixEncodedTx[i]=encodedTx[counter]
            counter=counter+1
        }

            return prefixEncodedTx;
       
    }
    
    enum CodingKeys: String,CodingKey{
        case sender = "snd"
        case fee = "fee"
        case type = "type"
        case firstValid = "fv"
        case lastValid = "lv"
        case note = "note"
        case genesisID="gen"
        case genesisHash="gh"
        case group="grp"
        case lease="lx"
        case rekeyTo="rekey"
        case amount="amt"
        case receiver="rcv"
        case closeRemainderTo="close"
        case voteFirst="votefst"
        case voteLast="votelst"
        case voteKeyDilution="votekd"
        case assetIndex="caid"
        case xferAsset="xaid"
        case assetAmount="aamt"
        case assetSender="asnd"
        case assetReceiver="arcv"
        case assetCloseTo="aclose"
        case freezeTarget="fadd"
        case assetFreezeID="faid"
        case freezeState="afrz"
        case applicationArgs="apaa"
        case onCompletion="apan"
        case accounts="apat"
        case foreignAssets="apas"
        case applicationId="apid"
          case assetParams="apar"
        case selectionPK="selkey"
          case foreignApps="apfa"
            case votePK="votekey"
          case localStateSchema="apls"
        case globalStateSchema="apgs"
        case clearStateProgram = "apsu"
        case approvalProgram = "apap"
        case innerTxns = "inner-txns"
        case logs = "logs"
    }
    
    
    

    
    public init() {
        self.type = Transaction.type.Default.rawValue;
            self.sender =  Address();
            self.fee = Account.MIN_TX_FEE_UALGOS;
            self.firstValid = 0;
            self.lastValid = 0;
            self.genesisID = nil;
            self.genesisHash =  Digest();
            self.group =  nil;
            self.rekeyTo =  nil;
            self.amount = nil;
            self.receiver =  nil;
            self.closeRemainderTo =  nil;
            self.voteFirst = nil;
            self.voteLast = nil;
            self.voteKeyDilution = nil;
            self.assetIndex = nil;
            self.xferAsset = nil;
            self.assetAmount = nil;
            self.assetSender =  nil;
            self.assetReceiver =  nil;
            self.assetCloseTo =  nil;
            self.freezeTarget =  nil
            self.assetFreezeID = nil;
            self.freezeState = nil;
        self.onCompletion =  nil;

            self.accounts = nil

            self.foreignAssets = nil;
            self.fee = nil;
        }
    
   public static func paymentTransactionBuilder() -> PaymentTransactionBuilder{
        return PaymentTransactionBuilder()
    }
  public  static func assetCreateTransactionBuilder()->AssetCreateTransactionBuilder{
        return AssetCreateTransactionBuilder()
    }
    
    
    public  static func assetConfigureTransactionBuilder()-> AssetConfigureTransactionBuilder {
        return AssetConfigureTransactionBuilder()
    
    }

    public static func assetDestroyTransactionBuilder()-> AssetDestroyTransactionBuilder {
        return AssetDestroyTransactionBuilder()
    }

    public  static func assetAcceptTransactionBuilder()-> AssetAcceptTransactionBuilder {
        return AssetAcceptTransactionBuilder()
    }
 
    public  static func assetTransferTransactionBuilder()->AssetTransferTransactionBuilder{
        return AssetTransferTransactionBuilder()
    }
    
    public  static func assetFreezeTransactionBuilder()->AssetFreezeTransactionBuilder{
        return AssetFreezeTransactionBuilder()
    }
    public  static func assetClawbackTransactionBuilder()->AssetClawbackTransactionBuilder{
        return AssetClawbackTransactionBuilder()
    }
    
    public static func applicationCreateTransactionBuilder() ->ApplicationCreateTransactionBuilder{
        return ApplicationCreateTransactionBuilder()
    }
    
    public static func applicationDeleteTransactionBuilder() ->ApplicationDeleteTransactionBuilder{
        return ApplicationDeleteTransactionBuilder()
    }
    
    public static func applicationOptInTransactionBuilder() ->ApplicationOptInTransactionBuilder{
        return ApplicationOptInTransactionBuilder()
    }
    
    public static func applicationClearTransactionBuilder() ->ApplicationClearTransactionBuilder{
        return ApplicationClearTransactionBuilder()
    }
    
    
    public static func applicationUpdateTransactionBuilder  () ->ApplicationUpdateTransactionBuilder{
        return ApplicationUpdateTransactionBuilder()
    }
    
    public static func applicationCallTransactionBuilder() -> ApplicationCallTransactionBuilder{
        return ApplicationCallTransactionBuilder()
    }
    
    public static func applicationCloseTransactionBuilder() -> ApplicationCloseTransactionBuilder{
        return ApplicationCloseTransactionBuilder()
    }
    
    
    
    
    
    
    
    
    
    public required init(from decoder: Decoder) throws {
           var container = try! decoder.container(keyedBy: CodingKeys.self)
          
        self.assetParams = try? container.decode(AssetParams.self, forKey: .assetParams)
           
           var senderAddress = try? container.decode(Data.self, forKey: .sender)

        var groupId = try? container.decode(Data.self, forKey: .group)
        if let group = groupId{
            self.group = try! Digest(CustomEncoder.convertToInt8Array(input: Array(group)))
        }
        self.assetSender = try? container.decode(Address.self, forKey: .assetSender)
        if let _ = senderAddress{
            self.sender = try! Address(CustomEncoder.convertToInt8Array(input: Array(senderAddress!)))
         
        }
         
        self.xferAsset = try? container.decode(Int64.self, forKey: .xferAsset)
        
        self.assetCloseTo = try? container.decode(Address.self, forKey: .assetCloseTo)
        
        self.assetReceiver = try? container.decode(Address.self, forKey: .assetReceiver)
        
        self.assetAmount = try? container.decode(Int64.self, forKey: .assetAmount)
        
        self.assetIndex = try? container.decode(Int64.self, forKey: .assetIndex)
        
        self.assetFreezeID = try? container.decode(Int64.self, forKey: .assetFreezeID)
        
        self.freezeState = try? container.decode(Bool.self,forKey: .freezeState)
        
        self.freezeTarget = try? container.decode(Address.self,forKey: .freezeTarget)
        
        self.genesisID = try? container.decode(String.self, forKey: .genesisID)
        
        self.closeRemainderTo = try? container.decode(Address.self,forKey: .closeRemainderTo)
        
        self.rekeyTo = try? container.decode(Address.self,forKey: .rekeyTo)
     
        
           var reciverAddress = try? container.decode(Data.self, forKey: .receiver)
        
        if let receiverAddr = reciverAddress{
            self.receiver = try! Address(CustomEncoder.convertToInt8Array(input: Array(receiverAddr)))
        }
         
           var noteBytes = try? container.decode(Data.self,forKey: .note)
        if let nB = noteBytes{
            self.note = CustomEncoder.convertToInt8Array(input: Array(nB))
        }
       
           self.lastValid = try? container.decode(Int64.self, forKey: .lastValid)
           self.firstValid = try? container.decode(Int64.self, forKey: .firstValid)
           self.amount = try? container.decode(Int64.self,forKey:.amount)
           self.type = try! container.decode(String.self,forKey: .type)
           self.fee = try! container.decode(Int64.self,forKey: .fee)
        
     var genesisID   = try? container.decode(String.self,forKey: .genesisID)
        
        
        if let gId = genesisID{
            self.genesisID=gId
        }
        var genesisHash = try? container.decode(Data.self, forKey: .genesisHash)
        if let genHash = genesisHash{
            self.genesisHash = try! Digest(CustomEncoder.convertToInt8Array(input: Array(genHash)))
        }
     
        var voteList = try? container.decode(Int64.self,forKey: .voteLast)
        if let vList=voteList{
            self.voteLast=voteList
        }
        
        var voteKd = try? container.decode(Int64.self,forKey: .voteKeyDilution)
        if let vKd=voteKd{
            self.voteKeyDilution=voteKd
        }
        
        
        var leaseData = try? container.decode(Data.self,forKey: .lease)
        if let lData=leaseData{
            self.lease = CustomEncoder.convertToInt8Array(input: Array(lData))
        }
        
        var voteKey = try? container.decode(Data.self, forKey: .votePK)
     
        
        
     if let vKey = voteKey{
        self.votePK = try! ParticipationPublicKey(bytes:
                                                    CustomEncoder.convertToInt8Array(input: Array(vKey)))
     }
        var sellKey = try? container.decode(Data.self, forKey: .selectionPK)
     
        if let sKey = sellKey{
           self.selectionPK = try! VRFPublicKey(bytes:
                                                       CustomEncoder.convertToInt8Array(input: Array(sKey)))
        }
        
        self.logs = Array()
         let ULogs = try? container.decode([Data].self, forKey: .logs)
        if let uLogs=ULogs{
            for i in 0..<uLogs.count{
               self.logs?.append(CustomEncoder.convertToInt8Array(input: Array(ULogs![i])))
            }
        }else{
            self.logs = nil
        }
        var innerTxns = try? container.decode([PendingTransactionResponse].self, forKey: .innerTxns)
        if let UInnerTxns = innerTxns{
            self.innerTxns = UInnerTxns
        }
       }
    
    
   public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let assetAmount=self.assetAmount{
            try! container.encode(assetAmount, forKey: .assetAmount)
        }
        
        if let assetCloseTo=self.assetCloseTo{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetCloseTo.getBytes())), forKey: .assetCloseTo)
        }
        
        if let freezeState=self.freezeState{
            if(freezeState){
                try!container.encode(freezeState, forKey: .freezeState)
            }
        }
        
        if let amount=self.amount{
            if(amount != 0){
                try! container.encode(amount, forKey: .amount)
            }
        }
    if let applicationArgs = self.applicationArgs{
        var UapplicationArgs:[Data]=Array()
    
        for i in 0..<applicationArgs.count{

            UapplicationArgs.append(Data(CustomEncoder.convertToUInt8Array(input: applicationArgs[i])))
        }
        
        try container.encode(UapplicationArgs, forKey: .applicationArgs)
    }
    
    if let  onCompletion = self.onCompletion{
        print(onCompletion)
        if(onCompletion != Transaction.onCompletion.NoOpOC){
            try! container.encode(onCompletion, forKey: .onCompletion)
        }
       
    }
    
    if let approvalProgram = self.approvalProgram{
        try! container.encode(approvalProgram, forKey: .approvalProgram)
    }
    
        if let assetParams=self.assetParams{
            try! container.encode(assetParams, forKey: .assetParams)
        }
    if let globalStateSchema = self.globalStateSchema{
        try! container.encode(globalStateSchema, forKey: .globalStateSchema)
    }
    
    if let applicationId = self.applicationId{
        try! container.encode(self.applicationId, forKey: .applicationId)
    }
    
    if let localStateSchema = self.localStateSchema{
        try! container.encode(localStateSchema, forKey: .localStateSchema)
    }
    
   
    
    if let clearStateProgramn = self.clearStateProgram{
        try! container.encode(clearStateProgram, forKey: .clearStateProgram)
    }
    
        if let assetReceiver=self.assetReceiver{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetReceiver.getBytes())), forKey: .assetReceiver)
        }
    
    if let assetSender = self.assetSender{
        try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetSender.getBytes())), forKey: .assetSender)
    }
    
        if let closeRemainderTo=self.closeRemainderTo{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: closeRemainderTo.getBytes())), forKey: .closeRemainderTo)
        }
        
        if let assetIndex=self.assetIndex{
            try!container.encode(assetIndex, forKey: .assetIndex)
        }
        
        if let freezeTarget=self.freezeTarget{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: freezeTarget.getBytes())), forKey: .freezeTarget)
        }
        if let assetFreezeId=self.assetFreezeID{
            try!container.encode(assetFreezeID, forKey: .assetFreezeID)
        }
        if let fee=self.fee{
            try! container.encode(fee, forKey: .fee)
        }
        if let firstValid=self.firstValid{
            if(firstValid != 0){
                try! container.encode(firstValid, forKey: .firstValid)
            }
     
        }
        if let genesisId=self.genesisID{
            try! container.encode(self.genesisID, forKey: .genesisID)
        }
        if let genesisHash=self.genesisHash{
            if let genesisHashBytes=genesisHash.bytes{
    
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: genesisHash.getBytes()!)), forKey: .genesisHash)
            }
        }
    
        if let group=self.group{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: group.getBytes()!)), forKey: .group)
        }
        if let lastValid=self.lastValid{
            try! container.encode(lastValid, forKey: .lastValid)
        }
    
    if let lease = self.lease{
        try!  container.encode(Data(CustomEncoder.convertToUInt8Array(input: lease)) , forKey: .lease)
    }
        if let note=self.note{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: note)), forKey: .note)
        }
        if let receiver=self.receiver{
            try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: receiver.getBytes())), forKey: .receiver)
        }
            
            if let rekeyTo = self.rekeyTo{
                try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: rekeyTo.getBytes())), forKey: .rekeyTo)
            }
            
    if let selectionKey = self.selectionPK{
        try!  container.encode(Data(CustomEncoder.convertToUInt8Array(input: selectionKey.bytes)) , forKey: .selectionPK)
    }
        if let sender=self.sender{
            try!  container.encode(Data(CustomEncoder.convertToUInt8Array(input: sender.getBytes())) , forKey: .sender)
        }
    
    try! container.encode(self.type, forKey: .type)
    
    if let voteKeyDilution = self.voteKeyDilution{
        if(voteKeyDilution != 0){
            try! container.encode(voteKeyDilution, forKey: .voteKeyDilution)
        }
 
    }
    
    if let votePk=self.votePK{
        try! container.encode(Data(CustomEncoder.convertToUInt8Array(input: votePk.bytes)), forKey: .votePK)
    }
    
    if let voteLast = self.voteLast{
        if(voteLast != 0){
            try! container.encode(voteLast, forKey: .voteLast)
        }
 
    }

        
        if let xferasset=self.xferAsset{
            try! container.encode(xferasset, forKey: .xferAsset)
        }
    if let logs = self.logs{
            var ULogs:[Data]=Array()

            for i in 0..<logs.count{

                ULogs.append(Data(CustomEncoder.convertToUInt8Array(input:logs[i])))
            }

            try container.encode(ULogs, forKey: .logs)
        }

    if let innerTxns = self.innerTxns{
        try container.encode(innerTxns, forKey: .innerTxns)
        }
    }

    
   public func   txID() -> String {
        let digest=SHA512_256().hash(self.bytesToSign())
        return CustomEncoder.encodeToBase32StripPad(digest)     
    }
    
    public func rawTxID()->Digest{
        return Digest(SHA512_256().hash(self.bytesToSign()))
    }
    
    public func assignGroupID(gid:Digest) {
            self.group = gid;
        }

    public func setLease(lease:Lease){
        self.lease = lease.getBytes()
    }
    public static func == (lhs:Transaction,rhs:Transaction)->Bool{
//        print(lhs.type == rhs.type )
//        print(lhs.sender == rhs.sender)
//        print(lhs.fee == rhs.fee)
//        print(lhs.firstValid == rhs.firstValid)
//        print(lhs.lastValid == rhs.lastValid )
//        print(  lhs.note == rhs.note)
//        print(lhs.genesisID == rhs.genesisID)
//        print(lhs.genesisHash?.bytes)
//        print(rhs.genesisHash?.bytes)
//        print(Digest() == Digest())
//
//        print( lhs.lease == rhs.lease)
//        print(lhs.group == rhs.group)
//        print(lhs.amount == rhs.amount)
//        print(lhs.receiver == rhs.receiver)
//        print(lhs.closeRemainderTo == rhs.closeRemainderTo)
//        print( lhs.votePK == rhs.votePK)
//        print(lhs.selectionPK == rhs.selectionPK)
//        print(lhs.selectionPK == rhs.selectionPK)
//        print(lhs.voteFirst == rhs.voteFirst)
//        print(lhs.voteLast == rhs.voteLast)
//        print(lhs.voteKeyDilution == rhs.voteKeyDilution)
//        print(lhs.assetParams)
//        print(rhs.assetParams)
//        print(lhs.assetParams == rhs.assetParams)
//        print(lhs.assetIndex == rhs.assetIndex)
//        print(lhs.xferAsset == rhs.xferAsset)
//        print(lhs.assetAmount == rhs.assetAmount)
//        print(lhs.assetSender?.bytes)
//        print(rhs.assetSender?.bytes)
//        print(lhs.assetSender == rhs.assetSender)
//        print(lhs.assetReceiver == rhs.assetReceiver)
//        print(lhs.assetCloseTo == rhs.assetCloseTo)
//        print(lhs.freezeTarget == rhs.freezeTarget )
//        print(lhs.assetFreezeID == rhs.assetFreezeID)
//        print(lhs.freezeState == rhs.freezeState)
//        print(lhs.rekeyTo == rhs.rekeyTo)
//        print(lhs.lease == rhs.lease)
//        print()
//        print()
//        print()
        
        
        
        return lhs.type == rhs.type && lhs.sender == rhs.sender && lhs.fee == rhs.fee
            && lhs.firstValid == rhs.firstValid && lhs.lastValid == rhs.lastValid &&
            lhs.note == rhs.note && lhs.genesisID == rhs.genesisID && lhs.genesisHash == rhs.genesisHash
            && lhs.lease == rhs.lease && lhs.group == rhs.group && lhs.amount == rhs.amount && lhs.receiver == rhs.receiver
            && lhs.closeRemainderTo == rhs.closeRemainderTo && lhs.votePK == rhs.votePK && lhs.selectionPK == rhs.selectionPK
            && lhs.voteFirst == rhs.voteFirst && lhs.voteLast == rhs.voteLast && lhs.voteKeyDilution == rhs.voteKeyDilution
            && lhs.assetParams == rhs.assetParams && lhs.assetIndex == rhs.assetIndex && lhs.xferAsset == rhs.xferAsset
            && lhs.assetAmount == rhs.assetAmount && lhs.assetSender == rhs.assetSender && lhs.assetReceiver == rhs.assetReceiver
            && lhs.assetCloseTo == rhs.assetCloseTo && lhs.freezeTarget == rhs.freezeTarget && lhs.assetFreezeID == rhs.assetFreezeID
            && lhs.freezeState == rhs.freezeState && lhs.rekeyTo == rhs.rekeyTo && lhs.lease == rhs.lease


    }
}


