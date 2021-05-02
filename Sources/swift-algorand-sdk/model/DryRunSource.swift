//
//  File.swift
//  
//
//  Created by Jesulonimi on 5/1/21.
//

import Foundation
public class DryrunSource : Codable{

    public init(){
        
    }

    public var appIndex:Int64?

    /**
     * FieldName is what kind of sources this is. If lsig then it goes into the
     * transactions[this.TxnIndex].LogicSig. If approv or clearp it goes into the
     * Approval Program or Clear State Program of application[this.AppIndex].
     */

    public var fieldName:String?

    public  var source:String?

    public var  txnIndex:Int64?
    
    enum CodingKeys:String,CodingKey{
        case appIndex = "app-index"
        case fieldName = "field-name"
        case source  =  "source"
        case txnIndex = "txn-index"
    }

}
