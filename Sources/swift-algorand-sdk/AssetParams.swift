//
//  File.swift
//  
//
//  Created by Jesulonimi on 2/6/21.
//

import Foundation
public class AssetParams: Codable {
    internal init(assetTotal: Int64?, assetDecimals: Int64?, assetDefaultFrozen: Bool?, assetUnitName: String?, assetName: String?, url: String? , metadataHash: [Int8]?, assetManager: Address? , assetReserve: Address?, assetFreeze: Address?, assetClawback: Address? ) {
        self.assetTotal = assetTotal
        self.assetDecimals = assetDecimals
        self.assetDefaultFrozen = assetDefaultFrozen
        self.assetUnitName = assetUnitName
        self.assetName = assetName
        self.url = url
        self.metadataHash = metadataHash
        self.assetManager = assetManager
        self.assetReserve = assetReserve
        self.assetFreeze = assetFreeze
        self.assetClawback = assetClawback
    }
    
    var assetTotal:Int64?
    var assetDecimals:Int64?
    var assetDefaultFrozen:Bool?
    var assetUnitName:String?
    var assetName:String?;
    var url:String?;
    var metadataHash:[Int8]?;
    var assetManager:Address?
    var  assetReserve:Address?;
    var assetFreeze:Address?;
    var assetClawback:Address?;
    
    
 
    
    enum CodingKeys:String,CodingKey{
        case assetTotal="t"
        case assetDecimals="dc"
        case assetDefaultFrozen="df"
        case assetUnitName="un"
        case assetName="an"
        case url="au"
        case metadataHash="am"
        case assetManager="m"
        case  assetReserve="r"
        case assetFreeze="f"
        case assetClawback="c"
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container=encoder.container(keyedBy: CodingKeys.self)
        if let metadatahash=self.metadataHash{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: metadatahash))  , forKey: .metadataHash)
        }
        if let assetName=self.assetName{
            try!container.encode(assetName, forKey: .assetName)
        }
    
        if let url=self.url{
            try!container.encode(url, forKey: .url)
        }
      
        if let assetClawBack=self.assetClawback{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetClawBack.getBytes())), forKey: .assetClawback)
          
        }
       
        if let assetDecimals=self.assetDecimals{
            if self.assetDecimals != 0{
                    try!container.encode(assetDecimals , forKey: .assetDecimals)
                }
        }
        
        
        if let assetDefaultFrozen=self.assetDefaultFrozen{
            if assetDefaultFrozen != false{
                    try!container.encode(assetDefaultFrozen, forKey: .assetDefaultFrozen)
                }
        }
   
        if let assetFreeze=self.assetFreeze{
             try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetFreeze.getBytes())), forKey: .assetFreeze)
        }
       
        if let assetManager=self.assetManager{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetManager.getBytes())), forKey: .assetManager)
        }
       
        if let assetReserve=self.assetReserve{
            try!container.encode(Data(CustomEncoder.convertToUInt8Array(input: assetReserve.getBytes())), forKey: .assetReserve)
        }
        if let assetTotal=self.assetTotal{
            try!container.encode(assetTotal, forKey: .assetTotal)
        }
        if let assetUnitName=self.assetUnitName{
            try!container.encode(assetUnitName , forKey: .assetUnitName)
          
          
        }
     
        
    }
    
//    enum CodingKeys:String,CodingKey{
//        case assetTotal="t"
//        case assetDecimals="dc"
//        case assetDefaultFrozen="df"
//        case assetUnitName="un"
//        case assetName="an"
//        case url="au"
//        case metadataHash="am"
//        case assetManager="m"
//        case assetReserve="r"
//        case assetFreeze="f"
//        case assetClawback="c"
//    }

//    public AssetParams(BigInteger assetTotal, Integer assetDecimals, boolean defaultFrozen, String assetUnitName, String assetName, String url, byte[] metadataHash, Address manager, Address reserve, Address freeze, Address clawback) {
//        this.assetTotal = BigInteger.valueOf(0L);
//        this.assetDecimals = 0;
//        this.assetDefaultFrozen = false;
//        this.assetUnitName = "";
//        this.assetName = "";
//        this.url = "";
//        this.assetManager = new Address();
//        this.assetReserve = new Address();
//        this.assetFreeze = new Address();
//        this.assetClawback = new Address();
//        if (assetTotal != null) {
//            this.assetTotal = assetTotal;
//        }
//
//        if (assetDecimals != null) {
//            this.assetDecimals = assetDecimals;
//        }
//
//        this.assetDefaultFrozen = defaultFrozen;
//        if (manager != null) {
//            this.assetManager = manager;
//        }
//
//        if (reserve != null) {
//            this.assetReserve = reserve;
//        }
//
//        if (freeze != null) {
//            this.assetFreeze = freeze;
//        }
//
//        if (clawback != null) {
//            this.assetClawback = clawback;
//        }
//
//        if (assetDecimals != null) {
//            if (assetDecimals < 0 || assetDecimals > 19) {
//                throw new RuntimeException("assetDecimals cannot be less than 0 or greater than 19");
//            }
//
//            this.assetDecimals = assetDecimals;
//        }
//
//        if (assetUnitName != null) {
//            if (assetUnitName.length() > 8) {
//                throw new RuntimeException("assetUnitName cannot be greater than 8 characters");
//            }
//
//            this.assetUnitName = assetUnitName;
//        }
//
//        if (assetName != null) {
//            if (assetName.length() > 32) {
//                throw new RuntimeException("assetName cannot be greater than 32 characters");
//            }
//
//            this.assetName = assetName;
//        }
//
//        if (url != null) {
//            if (url.length() > 32) {
//                throw new RuntimeException("asset url cannot be greater than 32 characters");
//            }
//
//            this.url = url;
//        }
//
//        if (metadataHash != null) {
//            if (metadataHash.length > 32) {
//                throw new RuntimeException("asset metadataHash cannot be greater than 32 bytes");
//            }
//
//            if (!Base64.isBase64(metadataHash)) {
//                throw new RuntimeException("asset metadataHash '" + new String(metadataHash) + "' is not base64 encoded");
//            }
//
//            this.metadataHash = metadataHash;
//        }
//
//    }
//
//    public AssetParams() {
//        this.assetTotal = BigInteger.valueOf(0L);
//        this.assetDecimals = 0;
//        this.assetDefaultFrozen = false;
//        this.assetUnitName = "";
//        this.assetName = "";
//        this.url = "";
//        this.assetManager = new Address();
//        this.assetReserve = new Address();
//        this.assetFreeze = new Address();
//        this.assetClawback = new Address();
//    }
//
//    public boolean equals(Object o) {
//        if (this == o) {
//            return true;
//        } else if (o != null && this.getClass() == o.getClass()) {
//            AssetParams that = (AssetParams)o;
//            return this.assetTotal.equals(that.assetTotal) && this.assetDecimals.equals(that.assetDecimals) && this.assetDefaultFrozen == that.assetDefaultFrozen && this.assetName.equals(that.assetName) && this.assetUnitName.equals(that.assetUnitName) && this.url.equals(that.url) && Arrays.equals(this.metadataHash, that.metadataHash) && this.assetManager.equals(that.assetManager) && this.assetReserve.equals(that.assetReserve) && this.assetFreeze.equals(that.assetFreeze) && this.assetClawback.equals(that.assetClawback);
//        } else {
//            return false;
//        }
//    }
//
//    @JsonCreator
//    private AssetParams(@JsonProperty("t") BigInteger assetTotal, @JsonProperty("dc") Integer assetDecimals, @JsonProperty("df") boolean assetDefaultFrozen, @JsonProperty("un") String assetUnitName, @JsonProperty("an") String assetName, @JsonProperty("au") String url, @JsonProperty("am") byte[] metadataHash, @JsonProperty("m") byte[] assetManager, @JsonProperty("r") byte[] assetReserve, @JsonProperty("f") byte[] assetFreeze, @JsonProperty("c") byte[] assetClawback) {
//        this(assetTotal, assetDecimals, assetDefaultFrozen, assetUnitName, assetName, url, metadataHash, new Address(assetManager), new Address(assetReserve), new Address(assetFreeze), new Address(assetClawback));
//    }
}
