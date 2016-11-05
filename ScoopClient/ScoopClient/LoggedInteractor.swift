//
//  LoggedInteractor.swift
//  PracticaAWS
//
//  Created by Juan Antonio Martin Noguera on 20/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import Foundation
import AWSCognito
import AWSCore



protocol LoggedInteractorInput {
    
    func doLoginInAWS(withCredential credential: String)
//    func removeRecord(item: PostEntry)
    
//    func readAllRecords()
//    func readAllMyRecords(_ me: String)
    
}


protocol LoggedInteractorOutput {
    
    func didAllRecords(_ records: [PostEntry]?)
}



class LoggedInteractor: NSObject, LoggedInteractorInput {

    var interactorOutput: LoggedInteractorOutput?
    var credentialsProvider: AWSCognitoCredentialsProvider?

    
    func startWithTwitterCredentials(_ credentials: CustomAWSProvider) {
        
        
        credentialsProvider = AWSCognitoCredentialsProvider(regionType: .euWest1,
                                                            identityPoolId: "eu-west-1:8e482ce0-358e-4948-98ff-923d7289b8c1",
                                                            identityProviderManager: credentials)
        
        let configuration = AWSServiceConfiguration(
            region:.euWest1, credentialsProvider:credentialsProvider)
        
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        credentialsProvider?.credentials().continue({ (task) -> Any? in
            return nil
            
        }).continue({ (task) -> Any? in
            
            return self.credentialsProvider?.getIdentityId().continue({ (task) -> Any? in
                
                if let _ = task.result {
                    print("Lo conseguimos")
                    
                    self.conginitoSyncUserData()
                }
                
                if let _ = task.error {
                    print(task.error?.localizedDescription)
                }
                if let _ = task.exception {
                    print(task.exception?.description)
                }
                
                return nil
            })
        })
        
        
    }
    
    
    func conginitoSyncUserData() {
        let syncClient = AWSCognito.default()
        
        let dataSet = syncClient?.openOrCreateDataset("twitterUser")
        
        if let _ = dataSet {
            
            if let aColor = dataSet?.string(forKey: "Color Theme") {
                DispatchQueue.main.async {
//                    self.navigationController?.navigationBar.barTintColor = UIColor(hexString: aColor)
                }
                
            } else {
                dataSet?.setString("2F84D9", forKey: "Color Theme");
            }
            
        }
        // creamos un dataset para clientes anonimos
        dataSet?.setString( "Auth", forKey: "Client Type")
        
        dataSet?.synchronize().continue({ (task) -> Any? in
            
            if task.isCancelled {
                print("la tarea fue cancelada")
                
            }
            
            if let _ = task.error {
                print("Tenemos un error: \(task.error)")
                
            }
            
            return nil
            
        })
        
        
    }

}

extension LoggedInteractor {
    func doLoginInAWS(withCredential credential: String) {
        
        let customProvider = CustomAWSProvider(tokens: [AWSIdentityProviderTwitter : credential])
        self.startWithTwitterCredentials(customProvider)
    }
}


















