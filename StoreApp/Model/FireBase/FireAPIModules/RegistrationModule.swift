//
//  RegistrationModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation
import Firebase

extension FireAPI {
    
    //    MARK: - Registration & Authorization
        
        func signIn(email: String, password: String, completion: (Bool) -> ()...){
            
            Auth.auth().signIn(withEmail: email, password: password) { [] authResult, error in
                
                if let error = error {
                    print("SignIn error: ", error)
                    completion[0](false)
                    
                } else {
                    
                    self.setUser(ID: authResult?.user.uid, email: email, password: password)
                    completion[0](true)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
                }
            }
        }
        
    private func setUser(ID: String?, email: String?, password: String?) {
            
            if ID != nil && email != nil && password != nil {
                
                db.collection(RootCollections.users.rawValue).document(ID!).getDocument { documentSnapshot, error in
                    if let error = error { print("Error getting user data: ", error); return }
                    
                    if documentSnapshot != nil {
                       
                        User.shared.set(UID: ID!,
                                        email: email!,
                                        password: password!,
                                        address: documentSnapshot?.get("address") as? String,
                                        fullName: documentSnapshot?.get("fullName") as! String,
                                        phoneNum: documentSnapshot?.get("phoneNum") as! Int)
                    }
                    
                    
                }
                
            } else {
                
                User.shared.remove()
            }
        }
        
        func signOut(){
            
           do {
               try Auth.auth().signOut()
               
           } catch let signOutError as NSError { print("Error signing out: %@", signOutError); return }
            
            setUser(ID: nil, email: nil, password: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name("SignedOut"), object: nil)
        }
        
    
    
        func registration(email: String, password: String, userName: String, adress: String, phoneNum: Int, completion: (Bool) -> ()...){
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if  (error != nil){
                    print("Registration error:", error!)
                    completion[0](false)
                    
                } else {
                    
                    completion[0](true)

                    self.setUser(ID: authResult?.user.uid, email: email, password: password)
                    self.createNewUserFiles(fullname: userName, address: adress, phoneNum: phoneNum)
     
                    
                    NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
                }
            }
        }
}
