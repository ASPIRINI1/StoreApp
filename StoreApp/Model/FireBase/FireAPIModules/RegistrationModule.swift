//
//  RegistrationModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation
import Firebase
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import GoogleSignIn

extension FireAPI {
    
    //    MARK: - Registration & Authorization
        
        func signIn(email: String, password: String, completion: (Bool) -> ()...){
            
            Auth.auth().signIn(withEmail: email, password: password) { [] authResult, error in
                
                if let error = error {
                    print("SignIn error: ", error)
                    completion[0](false)
                    
                } else {
                    
                    guard let authResult = authResult else { return }
                    self.setUser(ID: authResult.user.uid, email: email, password: password)
                    completion[0](true)
                }
            }
        }
        
    private func setUser(ID: String, email: String, password: String?) {
            
        db.collection(RootCollections.users.rawValue).document(ID).getDocument { documentSnapshot, error in
            if let error = error { print("Error getting user data: ", error); return }
            
            guard let documentSnapshot = documentSnapshot else { return }
                
            if documentSnapshot.get("fullName") == nil || documentSnapshot.get("phoneNum") == nil {
                print("No user data registred.")
            }
            
            User.shared.set(UID: ID,
                            email: email,
                            password: password,
                            address: documentSnapshot.get("address") as? String,
                            fullName: documentSnapshot.get("fullName") as? String ?? "",
                            phoneNum: documentSnapshot.get("phoneNum") as? Int ?? 0)
                

            NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
        }
                
    }
    
    private func removeUser() {
        User.shared.remove()
    }
        
        func signOut(){
            
           do {
               try Auth.auth().signOut()
               
           } catch let signOutError as NSError { print("Error signing out: %@", signOutError); return }
            
            removeUser()
            
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
    
    func appleLogInReguest() -> ASAuthorizationAppleIDRequest {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email,.fullName]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        
        return request
    }
    
    func googleLogIn(presentingVC: UIViewController, completion: @escaping (Bool)->()) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingVC) { [unowned presentingVC] user, error in

            if let error = error { print("Error google signIn: ", error); completion(false); return }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }
       
          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
             
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error { print("Error Google singIn: ", error); completion(false); return }
                
                guard
                    let authResult = authResult,
                    let userPhoneNum = Int(authResult.user.phoneNumber ?? "0"),
                    let userFullname = authResult.user.displayName
                else { return }
                
                self.createNewUserFiles(uid: authResult.user.uid, fullname: userFullname, address: "", phoneNum: userPhoneNum) {
                    self.setUser(ID: authResult.user.uid, email: authResult.user.email!, password: nil)
                    completion(true)
                }
            }
        }  
    }
    
    func facebookLogIn() {

    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
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
