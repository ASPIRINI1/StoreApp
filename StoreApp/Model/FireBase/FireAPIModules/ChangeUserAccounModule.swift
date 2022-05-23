//
//  ChangeUserAccounModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation

extension FireAPI {
    
    
//    MARK: Change user
    
    func deleteAccount() {
        
        currectUser?.delete { error in
            if let error = error { print("Error deleting user: ",error); return}
        }
        deleteUserFiles()
        signOut()
    }

    
    func changeUser(email: String, completion: @escaping (Bool) -> ()) {
        
        if !email.isEmpty {
            currectUser?.sendEmailVerification(beforeUpdatingEmail: email, completion: { error in
                
                if let error = error {
                    print("Error changing user email: ", error)
                    completion(false)
                    
                } else {
                    AppSettings.shared.userEmail = email
                    completion(true)
                }
            })
        }
    }
    
    func changeUser(password: String, completion: @escaping (Bool) -> ()) {
        
        if !password.isEmpty {
            currectUser?.updatePassword(to: password, completion: { error in
                
                if let error = error {
                    print("Error changing user password: ", error)
                    completion(false)

                } else {
                    completion(true)
                }
            })
        }
    }
    
    func changeUser(address: String, completion: @escaping (Bool) -> ()) {
        
        if !address.isEmpty {
            db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).updateData(["address" : address]) { error in
                
                if let error = error {
                    print("Error changing user address: ", error)
                    completion(false)
                    
                } else {
                    AppSettings.shared.userAddress = address
                    completion(true)
                }
            }
        }
    }
    
    func changeUser(phoneNum: Int, completion: @escaping (Bool) -> ()) {
        
        db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).updateData(["phoneNum" : phoneNum]) { error in
            
            if let error = error {
                print("Error changing phone num: ",error)
                completion(false)
                
            } else {
                AppSettings.shared.userPhoneNum = phoneNum
                completion(true)
            }
            
        }
    }
}
