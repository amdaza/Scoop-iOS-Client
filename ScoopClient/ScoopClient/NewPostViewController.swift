//
//  NewPostViewController.swift
//  PracticaAWS
//
//  Created by Juan Antonio Martin Noguera on 19/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import UIKit

import AWSCore
import AWSCognito
import AWSS3


class NewPostViewController: UIViewController {

    var s3Mgr: AWSS3TransferManager = AWSS3TransferManager.default()
    
    var userName: String?
    var userId: String?
    
    @IBOutlet weak var postTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadAction(_ sender: AnyObject) {
        uploadBlob()
    }

    func uploadBlob()  {
        
        let request = prepareRequest()
        
        s3Mgr.upload(request).continue ({ (task) -> Any? in
            
            if let _ = task.error {
                
                print(task.error)
            }
            
            if let _ = task.result {
                let blob = task.result as? AWSS3TransferManagerUploadOutput
                print(blob?.eTag)
            }
            return nil
        })
            
        
        
    }
    
    func prepareRequest() -> AWSS3TransferManagerUploadRequest{
        
        let request = AWSS3TransferManagerUploadRequest()
        
        request?.contentType = "image/jpg"
        request?.key = UUID().uuidString + ".jpg"
        request?.bucket = "practicaawsalumnos"
        request?.body =  Bundle.main.url(forResource: "winter-is-coming", withExtension: "jpg")
        
        
        return request!
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
