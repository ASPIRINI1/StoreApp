//
//  FireAPI.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import Foundation
import Firebase
//import GoogleSignIn

class APIManager{
    
    //    MARK: - Property
    
    static let shared = APIManager()
    private var docs = [Document]()
    var appSettings = AppSettings()
    var categories = [""]
    
    init() {
        getDocuments()
    }
    
    
//    MARK: - Configure DB & get from DB
    
     private func configureFB() -> Firestore{
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    private func getDocuments(){
        
//        if appSettings.userID != ""{
            
            let db = configureFB()
        db.collection("Products").getDocuments()  { (querySnapshot, err) in
                 
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in querySnapshot!.documents {
                         NotificationCenter.default.post(name: NSNotification.Name("LoadingNotes"), object: nil)
//                         self.docs.append(Document(id: document.documentID, text: document.get("text") as! String))
                         
//                         self.docs.append(Document(documentID: document.documentID,
//                                                   name: document.get("name") as! String,
//                                                   price: document.get("price") as! Int,
//                                                   img: "",
//                                                   description: document.get("description") as! String))
                         self.categories.append(document.documentID)
                     }
                     NotificationCenter.default.post(name: NSNotification.Name("NotesLoaded"), object: nil)
                 }
             }
//        }
     }
    
    
    func getProductsForCategory(category: String, subCategories: String){
        
        let db = configureFB()
        db.collection("Products").document(category).collection(subCategories).getDocuments { querySnapshot, error in
            if let err = error{
                print("Error getting documents for category: \(err)")
                NotificationCenter.default.post(name: NSNotification.Name( "DocsNotLoaded"), object: nil)
            } else {
                for document in querySnapshot!.documents{
                    self.docs.removeAll()
                    self.docs.append(Document(documentID: document.documentID,
                                              name: document.get("name") as! String,
                                              price: document.get("price") as! Int,
                                              img: "",
                                              description: document.get("description") as! String))
                }
                NotificationCenter.default.post(name: NSNotification.Name( "DocsLoaded"), object: nil)
            }
         }
    }

    //    MARK: - Create,Update,Delete documents
    
//    func createNewDocument(text: String){
//        let db = configureFB()
////        if appSettings.userID != ""{
//            let doc = db.collection("appSettings.userID").addDocument(data: ["text": text])
//            docs.append(Document(id:doc.documentID , text: text))
////        }
//        NotificationCenter.default.post(name: NSNotification.Name("NotesLoaded"), object: nil)
//   }
    
    func updateDocument(id: String, text:String){
        
       let db = configureFB()
        
        
       if text != ""{
           db.collection(appSettings.userID).document(id).updateData(["text": text]) { err in
                
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                for docIndex in 0...self.docs.count-1{
//                    if self.docs[docIndex].id == id{
//                        self.docs[docIndex].text = text
//                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name("NotesLoaded"), object: nil)
                print("Document successfully updated")
            }
           }
       }
    }
    
//    func deleteDocument(id: String){
//
//        let db = configureFB()
//
//        db.collection(appSettings.userID).document(id).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//
//        //removing document from local docs
//        for doc in 0...self.docs.count-1 {
//            if docs[doc].id == id{
//                self.docs.remove(at: doc)
//                break
//            }
//        }
//    }

    func getAllDocs() -> [Document]{
        return docs
    }
    
//    MARK: - Registration $ Authorization
    
    func signIn(email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                print("SignIn error")
            } else {
//                self?.appSettings.userID = authResult?.user.uid ?? ""
//                self!.appSettings.signedIn = true
//                self?.appSettings.userEmail = email
//                self?.getDocuments()
                
                NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
            }
          guard let strongSelf = self else { return }
        }
    }
    
    func signOut(){
        
        let firebaseAuth = Auth.auth()
       do {
         try firebaseAuth.signOut()
       } catch let signOutError as NSError {
         print("Error signing out: %@", signOutError)
           return
       }
        
//        self.docs.removeAll()
//        self.appSettings.signedIn = false
//        self.appSettings.userEmail = ""
//        self.appSettings.userID = ""
        
        NotificationCenter.default.post(name: NSNotification.Name("SignedOut"), object: nil)
    }
    
    func registration(email: String, password: String, completion: (Bool) -> ()...){
        
        let firebaseAuth = Auth.auth()
        let db = configureFB()
        
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if  (error != nil){
                print("Registration error")
                completion[0](false)
                
            } else {
//                self.appSettings.userID = authResult?.user.uid ?? ""
//                self.appSettings.userEmail = email
//                self.appSettings.signedIn = true
                
                completion[0](true)
                
                //uploading local docs to Firebase
                for doc in self.docs {
//                    db.collection(self.appSettings.userID).addDocument(data: ["text": doc.text])
                }
                NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
            }
        }
    }
    
}