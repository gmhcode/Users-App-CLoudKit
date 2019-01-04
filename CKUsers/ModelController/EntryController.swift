//
//  EntryController.swift
//  CKUsers
//
//  Created by Greg Hughes on 1/3/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    // MARK: - Properties
    
    typealias successCompletion = (_ success: Bool) -> Void
    
    static let shared = EntryController() ; private init(){}
    
    var entries = [Entry]()
    
    
    
    // MARK: - Crud
    func createEntryWith(text: String, completion: @escaping (Bool)->()){
        
        
        guard let loggedInPetOwner = PetOwnerController.shared.loggedInPetOwner else {completion(false) ; return}
        
        let loggedInPetOwnerRecord = CKRecord(petOwner: loggedInPetOwner)
        
        
        let petOwnerReference = CKRecord.Reference(record: loggedInPetOwnerRecord, action: .deleteSelf)
        
        let entry = Entry(text: text, petOwnerReference: petOwnerReference)
        
        save(entry: entry) { (success) in
            completion(success)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    func save(entry: Entry, completion: @escaping successCompletion){
        
        let entryToSaveRecord = CKRecord(entry)
        
        CKContainer.default().privateCloudDatabase.save(entryToSaveRecord) { (record, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let record = record,
                let entry = Entry(ckRecord: record)
                else {completion(false) ; return}
            
            self.entries.append(entry)
            completion(true)
        }
        
        
    }
    
    func fetchEntries(completion: @escaping successCompletion){
        
        
        guard let loggedInUser = PetOwnerController.shared.loggedInPetOwner else {completion(false) ; return}
        
        let predicate = NSPredicate(format: "petOwnerReference == %@", loggedInUser.ckRecordID)
        
        let query = CKQuery(recordType: Entry.EntryKeys.entry, predicate: predicate)
        
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let records = record else {completion(false) ; return}
        
            let fetchedEntries = records.compactMap { Entry(ckRecord: $0) }
            
            self.entries = fetchedEntries
            completion(true)
        
        }
        
        
    }
    
    func delete(entry: Entry, completion: @escaping successCompletion){
        
        
       
        
        CKContainer.default().privateCloudDatabase.delete(withRecordID: entry.ckRecordId) { (record, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            
            
            guard let record = record else {completion(false) ; return}
            
            let entryThatGotDeletedRecord = CKRecord(recordType: Entry.EntryKeys.entry, recordID: record)
            
            guard let indexPath = self.entries.firstIndex(where: { (entry) -> Bool in
                entry.ckRecordId == record
            })
                
                else {completion(false) ; return}
          
            self.entries.remove(at: indexPath)
            completion(true)
            
        }
        
        
    }
    
    
}
