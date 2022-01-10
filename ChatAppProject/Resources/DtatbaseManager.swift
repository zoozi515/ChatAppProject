//
//  DtatbaseManager.swift
//  ChatAppProject
//
//  Created by administrator on 09/01/2022.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

extension DatabaseManager{
    public func isUserExist(with email:String, completion: @escaping ((Bool) -> Void)){
        database.child(email).observeSingleEvent(of: .value, with: {snapshot in
            guard snapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true) //the email exist 
        })
    }
    
    
    ///insert user to db
    public func insertUser(with user: ChatAppUser){
        database.child(user.email).setValue([
            "first_name": user.first_name,
            "last_name": user.last_name
        ])
    }
}


struct ChatAppUser{
    let first_name: String
    let last_name: String
    let email: String
//    let profilePic: String
}
