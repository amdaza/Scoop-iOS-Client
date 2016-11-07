//
//  NewPostViewController.swift
//  PracticaAWS
//
//  Created by Juan Antonio Martin Noguera on 19/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import UIKit


class NewPostViewController: UIViewController {

    var client: MSClient = MSClient(applicationURL: URL(string: azureURL)!)
    
    @IBOutlet weak var postTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var authorName: UITextField!
    @IBOutlet weak var authorLastname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadAction(_ sender: AnyObject) {
        
        if let title = titleTxt.text,
            let content = postTxt.text,
            let userId = UserDefaults.standard
                .object(forKey: "userId") as? String {
            
            insertNewScoop(title: title,
                       content: content,
                       published: true,
                       authorId: userId)
        }
       
        //uploadAuthor()
        
        let storyBoardL = UIStoryboard(name: "Logged", bundle: Bundle.main)
        let vc = storyBoardL.instantiateViewController(withIdentifier: "loggedScene")
        
        self.present(vc, animated: true, completion: nil)
    }


    
    func uploadAuthor() {
        
    }
    
    func insertNewScoop(title: String,
                        content: String,
                        published: Bool,
                        authorId: String) {
        
        let tableMS = client.table(withName: "Scoops")
        
        tableMS.insert(["title": title,
                        "content": content,
                        "published": published,
                        "authorId": authorId]) { (result, error) in
            
            if let _ = error {
                print(error)
                return
            }
            
            print(result)
            
        }
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
