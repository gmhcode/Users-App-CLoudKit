//
//  PetOwner.swift
//  CKUsers
//
//  Created by Greg Hughes on 1/2/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import Foundation
import CloudKit




class PetOwner {
    // MARK: - properties
    let username: String
    let password: String
    let petName: String
    
    
    // Cloudkit
    var ckRecordID: CKRecord.ID
    let appleUserReference: CKRecord.Reference
    
    
    enum PetOwnerKeys  {
        static let usernameKey = "username"
        static let password = "password"
        static let petName = "petName"
        static let appleUserReference = "appleUserReference"
        static let petOwner = "PetOwner"
    }
    
    
    
    // MARK: - Initialization
    
    //Memberwise
    init(username: String, password: String, petName: String, appleUserReference: CKRecord.Reference, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.username = username
        self.password = password
        self.petName = petName
        self.appleUserReference = appleUserReference
        self.ckRecordID = ckRecordID
    }
    
    
    
    //convenience
    convenience init?(ckRecord: CKRecord){
        
        guard let username = ckRecord[PetOwnerKeys.usernameKey] as? String,
            let password = ckRecord[PetOwnerKeys.password] as? String,
            let petName = ckRecord[PetOwnerKeys.petName] as? String,
            let appleUserReference = ckRecord[PetOwnerKeys.appleUserReference] as? CKRecord.Reference
            else { return nil }
        
        
        
        self.init(username: username, password: password, petName: petName, appleUserReference: appleUserReference, ckRecordID: ckRecord.recordID)
        
        }
}

extension CKRecord{
    
    convenience init(petOwner: PetOwner) {
        
        
        self.init(recordType: PetOwner.PetOwnerKeys.petOwner, recordID: petOwner.ckRecordID )
        
        self.setValue(petOwner.username, forKey: PetOwner.PetOwnerKeys.usernameKey)
        self.setValue(petOwner.password, forKey: PetOwner.PetOwnerKeys.password)
        self.setValue(petOwner.petName, forKey: PetOwner.PetOwnerKeys.petName)
        self.setValue(petOwner.appleUserReference, forKey: PetOwner.PetOwnerKeys.appleUserReference)
        
    }
    
}





//let petOwner = PetOwner(username: "Jayden", password: "123", petName: "Halen", appleUserReference: CKRecord.Reference.initialize())
//
//let myPetOwnerRecord = CKRecord(petOwner: petOwner) // Saving
//
//let myFetchedPetOwner = PetOwner(ckRecord: myPetOwnerRecord) // Fetching
