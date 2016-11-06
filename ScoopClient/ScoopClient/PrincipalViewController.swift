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

let azureURL = "http://amdcboot3labs-mbaas.azurewebsites.net"

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
    
    func tryLogin (withProvider provider: String) {
        
        addEvent("Click_User_Logged", attribute: ("ClientType", provider))
        
        
        loadAuthInfo(withProvider: provider)
        
        if let _ = client.currentUser {
            
            goToLoggedMode()
        } else {
            
            clientLogin(withProvider: provider)
        }
    }
    

    @IBAction func userAnonymousAction(_ sender: AnyObject) {
        
        addEvent("Click_User_Anonymous", attribute: ("ClientType", "Anomymous"))
        let storyBoardA = UIStoryboard(name: "Anonymous", bundle: Bundle.main)
        let vc = storyBoardA.instantiateViewController(withIdentifier: "anonymousScene")
        
        present(vc, animated: true, completion: nil)
    }
    
    func goToLoggedMode() {
        
        let storyBoardL = UIStoryboard(name: "Logged", bundle: Bundle.main)
        let vc = storyBoardL.instantiateViewController(withIdentifier: "loggedScene")
        
        self.present(vc, animated: true, completion: nil)
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
                            
                            self.saveAuthInfo(user: user!, withProvider: provider)
                            self.goToLoggedMode()
                        }
        }

    }
    
    func saveAuthInfo(user: MSUser, withProvider provider: String) {
        
        UserDefaults.standard.set(user.userId!,
                                  forKey: provider + "userID")
        UserDefaults.standard.set(user.mobileServiceAuthenticationToken!,
                                  forKey: provider + "token")
        
        UserDefaults.standard.synchronize()
    }
    
    func loadAuthInfo(withProvider provider: String) {
        
        let userId = UserDefaults.standard
            .object(forKey: provider +  "userId") as? String
        let userToken = UserDefaults.standard
            .object(forKey: provider +  "userToken") as? String
        
        if userId != nil {
            self.client.currentUser = MSUser(userId: userId)
            self.client.currentUser?.mobileServiceAuthenticationToken = userToken
        }
        
    }
    
    func deleteAuthInfo() {
        
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userToken")
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
