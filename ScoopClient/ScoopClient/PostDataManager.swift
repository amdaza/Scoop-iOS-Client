//
//  PostDataManager.swift
//  PracticaAWS
//
//  Created by Juan Antonio Martin Noguera on 20/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import AWSCore
import AWSCognito
import AWSDynamoDB




protocol DataOperations {
    
    func addNewRecord(_ item: PostEntryDB)
    
    
}




class PostDataManager: NSObject, DataOperations {

    var dynamodbMapper: AWSDynamoDBObjectMapper?
    
    init?(mapper: AWSDynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()) {
        self.dynamodbMapper = mapper
    }
   
}

extension PostDataManager {
    
    func addNewRecord(_ item: PostEntryDB) {
        
        dynamodbMapper?.save(item).continue({ (task) -> Any? in
            
            if let _ = task.error {
                print(task.error)
            }
            if let _ = task.exception {
                print(task.exception)
            }
            if let _ = task.result {
                let result: AWSDynamoDBUpdateItemOutput = task.result as! AWSDynamoDBUpdateItemOutput
                print(result)
            }
            return nil
            
        })
    }
}





















