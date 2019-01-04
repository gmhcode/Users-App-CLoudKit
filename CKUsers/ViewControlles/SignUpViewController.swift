//
//  SignUpViewController.swift
//  CKUsers
//
//  Created by Greg Hughes on 1/2/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var petNameTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PetOwnerController.shared.fetchCurrentPetOwner { (sucecss) in
           DispatchQueue.main.async {
            if sucecss == true {
                self.performSegue(withIdentifier: "ToEntries", sender: self)
            }
            }
        }
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//            if segue.identifier == "ToEntries" {
//        
//            let destinationVC = segue.destination as! WelcomeViewController
//            let loggedInPetOwner = PetOwnerController.shared.loggedInPetOwner
//            destinationVC.petOwner = loggedInPetOwner
//        }
    }
    
    

    // MARK: - Actions
    @IBAction func signupButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text,
            username != "",
        let password = passwordTextField.text,
            password != "",
        let petname = petNameTextField.text,
            petname != "" else { return }
        
        
            
            PetOwnerController.shared.createPetOwner(with: username, password: password, petname: petname) { (success) in
                
                DispatchQueue.main.async {
                    
                self.performSegue(withIdentifier: "toWelcomeVC", sender: self)
                }
                
            print("Tapped")
            
        }
        
    }
}
