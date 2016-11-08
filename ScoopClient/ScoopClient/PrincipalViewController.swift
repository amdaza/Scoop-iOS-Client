//
//  PrincipalViewController.swift
//  PracticaAWS
//
//  Created by Juan Antonio Martin Noguera on 17/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import UIKit
//import AWSMobileAnalytics

typealias EventAttributes = (key: String, customValue: String)
typealias MetricAttribute = (key: String, valor: Double)

typealias AuthorRecord = Dictionary<String, AnyObject>
typealias ScoopRecord = Dictionary<String, AnyObject>

let azureURL = "https://amdcboot3labs-mbaas.azurewebsites.net"

class PrincipalViewController: UIViewController {

    //let mobileAnalytics = (UIApplication.shared.delegate as! AppDelegate).mobileAnalytics
    
    var client: MSClient = MSClient(applicationURL: URL(string: azureURL)!)
    
    var model: [AuthorRecord]? = []
    
    var startTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startTime = Date()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let lapsoTemporal = Date().timeIntervalSince(startTime!) as Double
        
        addEvent("Duracion-View",
                 attribute: ("Principal","View"),
                 metrics: ("Duration", lapsoTemporal))
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userLoggedAction(_ sender: AnyObject) {
        
        let provider = "twitter"
        
        tryLogin(withProvider: provider)

    }
    
    @IBAction func userLoginActionFacebook(_ sender: AnyObject) {
        
        let provider = "facebook"
        
        tryLogin(withProvider: provider)
    }
    
    func tryLogin (withProvider provider: String) {
        
        addEvent("Click_User_Logged", attribute: ("ClientType", provider))
        
        
        loadAuthInfo()
        
        if client.currentUser != nil {
            
            goToLoggedMode()
        } else {
            
            clientLogin(withProvider: provider)
        }
    }
    

    @IBAction func userAnonymousAction(_ sender: AnyObject) {
        
        addEvent("Click_User_Anonymous", attribute: ("ClientType", "Anomymous"))
        let storyBoardA = UIStoryboard(name: "Anonymous", bundle: Bundle.main)
        
        if let navController = storyBoardA.instantiateViewController(withIdentifier: "anonymousScene") as? UINavigationController {
            
            if let chidVC = navController.topViewController as? ScoopsTableViewController {

                chidVC.client = client
            }
            
            self.present(navController, animated: true, completion: nil)
        }
        
    }
    
    func goToLoggedMode() {
        
        let storyBoardL = UIStoryboard(name: "Logged", bundle: Bundle.main)
        
        if let navController = storyBoardL.instantiateViewController(withIdentifier: "loggedScene") as? UINavigationController {
       
            if let chidVC = navController.topViewController as? LoggedViewController {

                chidVC.client = client
            }
            
            self.present(navController, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - Authorization management
    
    func clientLogin(withProvider provider: String) {
        
        client.login(withProvider: provider,
                     parameters: nil,
                     controller: self,
                     animated: true) { (user, error) in
                        
                        if error != nil {
                            print("ERROR ", error)
                            return
                            
                        } else if user != nil {
                            
                            self.saveAuthInfo(user: user!)
                            self.goToLoggedMode()
                        }
        }

    }
    
    func saveAuthInfo(user: MSUser) {
        
        UserDefaults.standard.set(user.userId!,
                                  forKey: "userId")
        UserDefaults.standard.set(user.mobileServiceAuthenticationToken!,
                                  forKey: "userToken")
        
        UserDefaults.standard.synchronize()
    }
    
    func loadAuthInfo() {
        
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        let userToken = UserDefaults.standard.object(forKey: "userToken") as? String
        
        if userId != nil {
            self.client.currentUser = MSUser(userId: userId)
            self.client.currentUser?.mobileServiceAuthenticationToken = userToken
        }
        
    }
    
    
    func addEvent(_ eventType: String, attribute: EventAttributes, metrics: MetricAttribute? = nil)  {
        
        /*
        //let evento = mobileAnalytics?.eventClient.createEvent(withEventType: eventType)
        
        evento?.addAttribute(attribute.customValue, forKey: attribute.key)
        
        if let _ = metrics {
            evento?.addMetric(metrics?.valor as NSNumber!,
                              forKey: metrics?.key)
        }
        
        
        mobileAnalytics?
            .eventClient
            .record(evento)
        
        mobileAnalytics?
            .eventClient
        .submitEvents()
        */
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
