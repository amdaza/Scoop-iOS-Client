//
//  ScoopsTableViewController.swift
//  ScoopClient
//
//  Created by Home on 8/11/16.
//  Copyright © 2016 amdaza. All rights reserved.
//

import UIKit

class ScoopsTableViewController: UITableViewController {
    
    var client: MSClient?
    var model: [ScoopRecord]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readAllItemsInTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - CRUD Scoops table
    
    
    func readAllItemsInTable() {
        let tableMS = client?.table(withName: "Scoops")
        
        tableMS?.read { (results, error) in
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
    
    
    func tableView(withCellName cellId: String, _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        
        // Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // Configure the cell...
        let item = model?[indexPath.row]
        
        cell.textLabel?.text = item?["title"] as! String?
        
        return cell
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        if let destinationVC = segue.destination as? NewPostViewController{
            destinationVC.client = self.client
        }
        
    }

}
