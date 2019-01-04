//
//  PetOwnerController.swift
//  CKUsers
//
//  Created by Greg Hughes on 1/2/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation
import CloudKit

class PetOwnerController {
    
    // MARK: - Properties
    static let shared = PetOwnerController() ; private init() {}
        
    var loggedInPetOwner: PetOwner?
    
    
    
    // MARK: - Crud
    
    //Create PetOwner
    func createPetOwner(with username: String, password: String, petname: String, completion: @escaping (_ success: Bool) -> ()){
        
        //Fetch the "iCloud user" record ID.
        CKContainer.default().fetchUserRecordID { (appleUserRecordId, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let appleUserRecordId = appleUserRecordId else {completion(false) ; return}
            
            let referenceToAppleUser = CKRecord.Reference(recordID: appleUserRecordId, action: .deleteSelf)
            //lets icloud know whos default user id it is
            let newPetOwner = PetOwner(username: username, password: password, petName: petname, appleUserReference: referenceToAppleUser)
            
            self.save(petOwner: newPetOwner, completion: { (success) in
                completion(success)
            })
            
        }
    }
    
    
    
    
    func save(petOwner: PetOwner, completion: @escaping (Bool)-> ()){
        
        
        let petOwnerRecord = CKRecord(petOwner: petOwner)
        
        CKContainer.default().privateCloudDatabase.save(petOwnerRecord) { (record, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let record = record else {completion(false) ; return}
            guard let loggedInPetOwner = PetOwner(ckRecord: record) else {completion(false) ; return}
            
            self.loggedInPetOwner = loggedInPetOwner
            
            completion(true)
        }
    }
    
    
    
    
    
    //Fetch PetOwner
    func fetchCurrentPetOwner(completion: @escaping (_ success: Bool) ->()) {
        
        //Fetch User Record ID
        CKContainer.default().fetchUserRecordID { (record, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let appleUserRecordID = record else {completion(false) ; return}
         
            //predicate / Query
            
            let predicate = NSPredicate(format: "appleUserReference == %@", appleUserRecordID )
            let query = CKQuery(recordType: PetOwner.PetOwnerKeys.petOwner, predicate: predicate)
            //tells computer what to retrieve in cloud
            
            // Perform on the database w/ query -> CKRecords
            CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let records = records,
                    let firstRecord = records.first else {completion(false) ; return}
                
                let loggedInPetOwner = PetOwner(ckRecord: firstRecord)
                
                self.loggedInPetOwner = loggedInPetOwner
                completion(true)
                
            })
        }
    }
}
