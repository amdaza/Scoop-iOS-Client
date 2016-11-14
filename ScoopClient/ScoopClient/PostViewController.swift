//
//  PostViewController.swift
//  ScoopClient
//
//  Created by Home on 14/11/16.
//  Copyright © 2016 amdaza. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var model: ScoopRecord?

    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = model?["title"] as! String?
        self.postTextView.text = model?["content"] as! String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
