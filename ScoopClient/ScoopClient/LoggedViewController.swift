//
//  LoggedViewController.swift
//  PracticaAWS
//
//  Created by Juan Antonio Martin Noguera on 17/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import UIKit
//import TwitterKit



class LoggedViewController: ScoopsTableViewController{
    
    @IBAction func backButton(_ sender: AnyObject) {
    
        let storyBoardA = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let navController = storyBoardA.instantiateViewController(withIdentifier: "firstView") as? UINavigationController {
            
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func logoutAction(_ sender: AnyObject) {
        
        deleteAuthInfo()
        
        let storyBoardL = UIStoryboard(name: "Anonymous", bundle: Bundle.main)
        
        if let navController = storyBoardL.instantiateViewController(withIdentifier: "anonymousScene") as? UINavigationController {
            
            if let chidVC = navController.topViewController as? AnonymousTableViewController {
                
                chidVC.client = client
            }
            
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    
    func deleteAuthInfo() {
        
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userToken")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // readAllItemsInTable()
    }
    
    // MARK: - CRUD Scoops table
    
    func deleteScoopRecord(item: ScoopRecord) {
        
        let tableMS = client?.table(withName: "Scoops")
        
        tableMS?.delete(item) { (result, error) in
            
            if let _ = error {
                print(error)
                return
            }
            
            // Refresh table
            self.readAllItemsInTable()
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let item = self.model?[indexPath.row]
            
            let authorId = UserDefaults.standard
                .object(forKey: "userId") as? String
            
            if item?["userId"] as? String == authorId {
                self.deleteScoopRecord(item: item!)
                self.model?.remove(at: indexPath.row)
                
                tableView.endUpdates()
            }
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return super.tableView(withCellName: "loggedCell", tableView, cellForRowAt: indexPath)
    }
    

}























