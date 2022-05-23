//
//  RegistrationModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation
import Firebase

extension FireAPI {
    
    //    MARK: - Registration $ Authorization
        
        func signIn(email: String, password: String, completion: (Bool) -> ()...){
            
            Auth.auth().signIn(withEmail: email, password: password) { [] authResult, error in
                
                if let error = error {
                    print("SignIn error: ", error)
                    completion[0](false)
                    
                } else {
                    
                    self.setUser(userID: authResult?.user.uid, email: email)
                    completion[0](true)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
                }
            }
        }
        
        private func setUser(userID: String?, email: String) {
            
            if userID != nil {
                
                AppSettings.shared.signedIn = true
                AppSettings.shared.userID = userID!
                AppSettings.shared.userEmail = email
                
                db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).getDocument { documentSnapshot, error in
                    if let error = error { print("Error getting user data: ", error); return }
                    
                    if documentSnapshot != nil {
                        AppSettings.shared.userFullName = documentSnapshot?.get("fullName") as! String
                        AppSettings.shared.userAddress = documentSnapshot?.get("address") as! String
                        AppSettings.shared.userPhoneNum = documentSnapshot?.get("phoneNum") as! Int
                    }
                }
                
            } else {
                
                AppSettings.shared.signedIn = false
                AppSettings.shared.userEmail = ""
                AppSettings.shared.userID = ""
                AppSettings.shared.userAddress = ""
                AppSettings.shared.userFullName = ""
                AppSettings.shared.userPhoneNum = 0
            }
        }
        
        func signOut(){
            
           do {
               try Auth.auth().signOut()
               
           } catch let signOutError as NSError { print("Error signing out: %@", signOutError); return }
            
            setUser(userID: nil, email: "")
            
            NotificationCenter.default.post(name: NSNotification.Name("SignedOut"), object: nil)
        }
        
        func registration(email: String, password: String, userName: String, adress: String, phoneNum: Int, completion: (Bool) -> ()...){
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if  (error != nil){
                    print("Registration error:", error!)
                    completion[0](false)
                    
                } else {
                    
                    completion[0](true)

                    self.setUser(userID: authResult?.user.uid, email: email)
                    self.createNewUserFiles(fullname: userName, address: adress, phoneNum: phoneNum)
     
                    
                    NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
                }
            }
        }
}
