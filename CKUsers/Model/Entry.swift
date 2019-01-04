//
//  Entry.swift
//  CKUsers
//
//  Created by Greg Hughes on 1/3/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    // MARK: - Properties
    let text : String
    let timestamp : Date
    
    //CloudKit
    let ckRecordId: CKRecord.ID
    let petOwnerReference: CKRecord.Reference
    
    // MARK: - Keys
    enum EntryKeys {
        static let text = "text"
        static let timestamp = "timestamp"
        static let petOwnerReference = "petOwnerReference"
        static let entry = "Entry"
    }
    
    
    // MARK: - Initialization
    init(text:String, timestamp: Date = Date(), ckRecordId: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), petOwnerReference: CKRecord.Reference) {
        
        self.text = text
        self.timestamp = timestamp
        self.ckRecordId = ckRecordId
        self.petOwnerReference = petOwnerReference
    }
    
    
    
    init?(ckRecord: CKRecord){
        
        guard let text = ckRecord[EntryKeys.text] as? String,
        let timestamp = ckRecord[EntryKeys.timestamp] as? Date,
        let petOwnerReference = ckRecord[EntryKeys.petOwnerReference] as? CKRecord.Reference else { return nil }
        
        let ckRecordID = ckRecord.recordID
        
        
        
        self.text = text
        self.timestamp = timestamp
        self.ckRecordId = ckRecordID
        self.petOwnerReference = petOwnerReference
    }
    
    
}

extension CKRecord {
    convenience init(_ entry: Entry){
        
        self.init(recordType: Entry.EntryKeys.entry, recordID: entry.ckRecordId)
        
        setValue(entry.text, forKey: Entry.EntryKeys.text)
        setValue(entry.timestamp, forKey: Entry.EntryKeys.timestamp)
        setValue(entry.petOwnerReference, forKey: Entry.EntryKeys.petOwnerReference)
        
    }
}
