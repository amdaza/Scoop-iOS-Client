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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return super.tableView(withCellName: "loggedCell", tableView, cellForRowAt: indexPath)
    }
    

}























