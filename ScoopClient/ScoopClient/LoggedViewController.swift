//
//  LoggedViewController.swift
//  PracticaAWS
//
//  Created by Juan Antonio Martin Noguera on 17/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import UIKit
//import TwitterKit


class LoggedViewController: UITableViewController/*, LoggedInteractorOutput */{
    
    //var model: [PostEntry] = []
    var client: MSClient = MSClient(applicationURL: URL(string: "http://amdcboot3labs-mbaas.azurewebsites.net")!)
    
    var model: [AuthorRecord]? = []
    
    
    var interactorInput: LoggedInteractorInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readAllItemsInTable()
    }
    
    /*
    func injectedDependencies() {
        
        let interactorLogged = LoggedInteractor()
        
        self.interactorInput = interactorLogged
        interactorLogged.interactorOutput = self
        
    }
   */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - CRUD Authors table
    
    func insertNewAuthor(name: String, lastname: String) {
        let tableMS = client.table(withName: "Authors")
        
        tableMS.insert(["name": name, "lastname": lastname]) { (result, error) in
            
            if let _ = error {
                print(error)
                return
            }
            
            print(result)
            
        }
    }
    
    func deleteAuthorRecord(item: AuthorRecord) {
        
        let tableMS = client.table(withName: "Authors")
        
        tableMS.delete(item) { (result, error) in
            
            if let _ = error {
                print(error)
                return
            }
            
            // Refresh table
            self.readAllItemsInTable()
        }
    }
    
    func readAllItemsInTable() {
        let tableMS = client.table(withName: "Authors")
        //  let predicate = NSPredicate(format: "name = 'Juan Martin'")
        
        tableMS.read { (results, error) in
            if let _ = error {
                print(error)
                return
            }
            
            if !((self.model?.isEmpty)!) {
                self.model?.removeAll()
            }
            
            if let items = results {
                for item in items.items! {
                    self.model?.append(item as! [String: AnyObject])
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (model?.isEmpty)! {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (model?.isEmpty)! {
            return 0
        }
        
        return (model?.count)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model?[indexPath.row]
        
        performSegue(withIdentifier: "detailAuthor", sender: item)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Cell type
        let cellId = "loggedCell"
        
        // Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // Configure the cell...
        let item = model?[indexPath.row]
        
        cell.textLabel?.text = item?["name"] as! String?
        
        return cell
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let item = self.model?[indexPath.row]
            
            self.deleteAuthorRecord(item: item!)
            self.model?.remove(at: indexPath.row)
            
            tableView.endUpdates()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

}
/*

extension LoggedViewController {
    
    func didAllRecords(_ records: [PostEntry]?) {
        
        if let _ = records {
            model = records!
            tableView.reloadData()
        }
        
    }
}

*/

























