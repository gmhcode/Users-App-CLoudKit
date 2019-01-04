//
//  EntriesTableViewController.swift
//  CKUsers
//
//  Created by Greg Hughes on 1/3/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
   
        
    
   
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = PetOwnerController.shared.loggedInPetOwner?.username ?? "nil"
        fetchEntries()
        
        
    }
    func fetchEntries(){
        EntryController.shared.fetchEntries { (success) in
            if success{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func plusButtonTapped(_ sender: Any) {
        presentEntryAlert()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EntryController.shared.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        
        cell.textLabel?.text = entry.text
        cell.detailTextLabel?.text = entry.timestamp.asString
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let entry = EntryController.shared.entries[indexPath.row]
            
            EntryController.shared.delete(entry: entry) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    
    
}

extension EntriesTableViewController{
    
    func presentEntryAlert(){
        
        let alertController = UIAlertController(title: "Add Pet Entry", message: "Halen is the best dog", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Add what you love about your pet here"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            //code for adding an entry
            //TODO: - AddEntry logic
            guard let entryText = alertController.textFields?[0].text else {return}
            EntryController.shared.createEntryWith(text: entryText, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
        
        
    }
}

extension Date{
    
    var asString: String{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
}
