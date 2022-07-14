//
//  ChangeUserAccounModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation
import FirebaseAuth

extension FireAPI {
    
    
//    MARK: Change user
    
    func deleteAccount(completion: @escaping (Bool)->()) {
        
        guard let user = AppSettings.shared.user else { return }
        
        signIn(email: user.email, password: user.password!) { signedIn in
            guard signedIn else { return }
            
            self.currectUser?.delete { error in
                if let error = error { print("Error deleting user: ",error); completion(false); return}
                
                self.deleteUserFiles()
                self.signOut()
                completion(true)
            }
        }
    }

    
    func changeUser(email: String, completion: @escaping (Bool) -> ()) {
        
        guard !email.isEmpty else { return }
        guard let user = currectUser else { return }
        guard let thisUser = AppSettings.shared.user else { return }
        signOut()
        
        signIn(email: thisUser.email, password: thisUser.password!) { success in
            
            guard success else { return }
            
            user.sendEmailVerification(beforeUpdatingEmail: email) { error in
                if let error = error {
                    print("Error sending email update verification: ", error)
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    func changeUser(password: String, completion: @escaping (Bool) -> ()) {
        
        guard !password.isEmpty else { return }
        
        guard let email = AppSettings.shared.user?.email else { return }
        
        signIn(email: email, password: AppSettings.shared.user!.password!) { success in
            if !success { return }
            
            self.currectUser!.updatePassword(to: password, completion: { error in
                
                guard let error = error else { completion(true); return }
                print("Error changing user password: ", error)
                completion(false)
            })
        }
    }
    
    func changeUser(address: String, completion: @escaping (Bool) -> ()) {
        
        guard let userID = AppSettings.shared.user?.userID else { return }
        
        db.collection(RootCollections.users.rawValue).document(userID).updateData(["address" : address]) { error in
            
            if let error = error {
                print("Error changing user address: ", error)
                completion(false)
                
            } else {
                AppSettings.shared.user?.address = address
                completion(true)
            }
        }
    }
    
    func changeUser(phoneNum: Int, completion: @escaping (Bool) -> ()) {
        
        guard let userID = AppSettings.shared.user?.userID else { return }
        
        db.collection(RootCollections.users.rawValue).document(userID).updateData(["phoneNum" : phoneNum]) { error in
            
            if let error = error {
                print("Error changing phone num: ",error)
                completion(false)
                
            } else {
                AppSettings.shared.user?.phoneNum = phoneNum
                completion(true)
            }
            
        } 
    }
}
