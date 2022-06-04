//
//  RegistrationModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation
import Firebase
import FirebaseAuth

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
                        
                        if documentSnapshot?.get("fullName") == nil || documentSnapshot?.get("phoneNum") == nil {
                            print("Error loading user data.")
                        }
                       
                        User.shared.set(UID: ID!,
                                        email: email!,
                                        password: password!,
                                        address: documentSnapshot?.get("address") as? String,
                                        fullName: documentSnapshot?.get("fullName") as? String ?? "",
                                        phoneNum: documentSnapshot?.get("phoneNum") as? Int ?? 0)
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
        
    
    
        func registration(email: String, password: String, userName: String, address: String, phoneNum: Int, completion: (Bool) -> ()...){
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                if error != nil {
                    print("Registration error:", error!)
                    completion[0](false)
                }
                
                guard let authResult = authResult else {
                    return
                }
                
                self.createNewUserFiles(uid: authResult.user.uid, fullname: userName, address: address, phoneNum:   phoneNum) {
                    self.setUser(ID: authResult.user.uid, email: email, password: password)
                    NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
                    completion[0](true)
                }
            }
        }
    
    func appleLogIn() {
        
    }
    
    func googleLogIn() {
        
    }
    
    func facebookLogIn() {
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    
}
