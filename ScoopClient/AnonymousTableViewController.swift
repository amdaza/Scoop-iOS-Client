//
//  ScoopsTableViewController.swift
//  ScoopClient
//
//  Created by Home on 30/10/16.
//  Copyright © 2016 Alicia. All rights reserved.
//

import UIKit


class AnonymousTableViewController: ScoopsTableViewController {
    
    @IBAction func backButton(_ sender: AnyObject) {
        let storyBoardA = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let navController = storyBoardA.instantiateViewController(withIdentifier: "firstView") as? UINavigationController {
            
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return super.tableView(withCellName: "anonymousCell", tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model?[indexPath.row]
        
        performSegue(withIdentifier: "postDetail", sender: item)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "postDetail" {
            let vc = segue.destination as? PostViewController
            
            vc?.model = sender as? ScoopRecord
        }
    }
 
    
}
