//
//  NewPostViewController.swift
//  PracticaAWS
//
//  Created by Juan Antonio Martin Noguera on 19/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import UIKit


class NewPostViewController: UIViewController {

    var client: MSClient?
    var author: [AnyHashable: Any]?
    
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var authorName: UITextField!
    @IBOutlet weak var authorLastname: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        readAuthor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadAction(_ sender: AnyObject) {
        
        let authorId = UserDefaults.standard
            .object(forKey: "userId") as? String
        
        if let title = titleTxt.text,
            let content = postTextView.text,
            let userId = authorId{
            
            insertNewScoop(title: title,
                       content: content,
                       published: true,
                       authorId: userId)
            
            if let name = authorName.text,
                let lastname = authorLastname.text{
                
                if name != self.author?["name"] as? String
                    && lastname != self.author?["lastname"] as? String{
                
                    upsertAuthor(name: name,
                                 lastname: lastname,
                                 userId: userId)
                }
            }
        }
 
        let _ = self.navigationController?.popViewController(animated: true)
    }

    
    
    func insertNewScoop(title: String,
                        content: String,
                        published: Bool,
                        authorId: String) {
        
        let tableMS = client?.table(withName: "Scoops")
        
        tableMS?.insert(["title": title,
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
    
    func readAuthor() {
        
        if let userId = UserDefaults.standard
            .object(forKey: "userId") as? String{
            
            // Create a predicate that finds items where complete is false
            let predicate =  NSPredicate(format: "userId == %@", userId)
        
            let tableMS = client?.table(withName: "Authors")
        
            // Query the table
            tableMS?.read(with: predicate) { (result, error) in
            
                if let err = error {
                    print("ERROR ", err)
                    
                } else if let items = result?.items {
                
                    if items.count > 0 {
                    
                        self.author = items.first
                    
                        DispatchQueue.main.async {
                            self.authorName.text = self.author?["name"] as! String?
                            self.authorLastname.text = self.author?["lastname"] as! String?
                        }
                    }
                }
            }

        }
        
           }

    
    func upsertAuthor(name: String,
                      lastname: String,
                      userId: String) {
        if let auth = self.author {
                    
            self.updateAuthor(author: auth,
                                          parameters: nil)
            
        } else {
            self.insertAuthor(name: name, lastname: lastname, userId: userId)
        }
        
    }
    
    func updateAuthor(author: [AnyHashable: Any],
                      parameters: [AnyHashable: Any]?) {

        let tableMS = client?.table(withName: "Authors")
        
        tableMS?.update(author, parameters: parameters, completion: { (result, error) -> Void in
            if let err = error {
                print("ERROR ", err)
            } else if let item = result {
                print(item)
            }
        })

    }
    
    func insertAuthor(name: String,
                      lastname: String,
                      userId: String) {
        let tableMS = client?.table(withName: "Authors")
        
        tableMS?.insert(["name": name,
                         "lastname": lastname,
                         "userId": userId]) { (result, error) in
                            
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
