//
//  ScoopsTableViewController.swift
//  ScoopClient
//
//  Created by Home on 30/10/16.
//  Copyright © 2016 Alicia. All rights reserved.
//

import UIKit

typealias AuthorRecord = Dictionary<String, AnyObject>

class ScoopsTableViewController: UITableViewController {
        
    
    var client: MSClient = MSClient(applicationURL: URL(string: "http://amdcboot3labs-mbaas.azurewebsites.net")!)
    
    var model: [AuthorRecord]? = []
    /*
    @IBAction func addNewAuthor(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Author", message: "Write Author's name", preferredStyle: .alert)
        
        
        let actionOk = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let nameAutor = alert.textFields![0] as UITextField
            let secondName = alert.textFields![1] as UITextField
            
            
            self.insertNewAuthor(name: nameAutor.text!, lastname: secondName.text!)
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        alert.addTextField { (textField) in
            
            textField.placeholder = "Insert Author's name"
            
        }
        
        alert.addTextField {(textfield2) in
            textfield2.placeholder = "Insert lastname"
        }
        present(alert, animated: true, completion: nil)
    }
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        //insertNewAuthor(name: "Carlos", lastname: "Ruiz Zafón")
        
        readAllItemsInTable()
        
    }
    
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
        let cellId = "ScoopCell"
        
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            // Optional empty, create one
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        
        // Configure the cell...
        let item = model?[indexPath.row]
        
        cell?.textLabel?.text = item?["name"] as! String?
        
        return cell!
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
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailAuthor" {
            let vc = segue.destination as? AuthorDetailViewController
            
            vc?.client = client
            vc?.model = sender as? AuthorRecord
        }
    }
 */
}
