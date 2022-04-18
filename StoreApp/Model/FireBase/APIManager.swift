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
    var docs: [Document] = []
    var appSettings = AppSettings()
//    var categories: [(String, [String])] = []
    var categories: [[String]] = []
    
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
//                         self.categories.append(document.documentID)
                     }
                     NotificationCenter.default.post(name: NSNotification.Name("NotesLoaded"), object: nil)
                 }
             }
//        }
     }
    
    
    func getProductsForCategory(category: String, subCategories: String){
        
        let db = configureFB()
        db.collection("Products").document(category).collection(subCategories).getDocuments() { querySnapshot, error in
            
            if let err = error{
                
                print("Error getting documents for category: \(err)")
                NotificationCenter.default.post(name: NSNotification.Name( "DocsNotLoaded"), object: nil)
                
            } else {
                
                for document in querySnapshot!.documents{
                    
                    NotificationCenter.default.post(name: NSNotification.Name( "LoadingDocs"), object: nil)
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
    
    func getImageForProduct(category: String, subCategory: String, completion: @escaping ([UIImage]?) -> ()) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let productsRef = storageRef.child(category + "/" + subCategory).child("first")
        var images: [UIImage]? = []
        
        productsRef.listAll(completion: { imageList, error in
            if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
            
            for image in imageList.items {
                image.getData(maxSize: 99 * 1024 * 1024) { data, error in //??
                    
                    if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
                    
                    if data != nil {
                        images?.append(UIImage(data: data!)!)
                        completion(images)
                    }
                }
            }
        })
    }
    
    func getCategories() {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        storageRef.listAll { storageListResult, err in
            
            if err == nil {
                for category in storageListResult.prefixes {
                    
                    self.categories.append([category.name])
                    
                    storageRef.child(self.categories.last!.first!).listAll { result, err in
                        if err != nil { print("Error getting SubCategory") ; return}
                        
                        for subCategory in result.prefixes {
                            self.categories[self.categories.endIndex-1].append(subCategory.name)
                            self.appSettings.categories = self.categories
                        }
                    }
                }
                
            } else {
                print("Getting category error : ", err!)
            }
        }
    }

    //    MARK: - Create,Update,Delete documents
    
    func createNewDocument(text: String){
        let db = configureFB()
        if appSettings.userID != ""{
        db.collection("Users").addDocument(data: [appSettings.userID : ":"])
        }
        NotificationCenter.default.post(name: NSNotification.Name("NotesLoaded"), object: nil)
   }
    
//    func updateDocument(id: String, text:String){
//
//       let db = configureFB()
//
//
//       if text != ""{
//           db.collection(appSettings.userID).document(id).updateData(["text": text]) { err in
//
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                for docIndex in 0...self.docs.count-1{
////                    if self.docs[docIndex].id == id{
////                        self.docs[docIndex].text = text
////                    }
//                }
//                NotificationCenter.default.post(name: NSNotification.Name("NotesLoaded"), object: nil)
//                print("Document successfully updated")
//            }
//           }
//       }
//    }
    
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
    
    func getDocForID(id: String) -> Document?{
        
        for doc in docs {
            if doc.documentID == id{
                return doc
            }
        }
        return nil
    }
    
//    MARK: - Registration $ Authorization
    
    func signIn(email: String, password: String, completion: (Bool) -> ()...){
        
        Auth.auth().signIn(withEmail: email, password: password) { [] authResult, error in
            if error != nil {
                print("SignIn error")
                completion[0](false)
            } else {
                self.appSettings.userID = authResult?.user.uid ?? ""
                self.appSettings.signedIn = true
                self.appSettings.userEmail = email
                self.getDocuments()
                completion[0](true)
                
                NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
            }
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
//                for doc in self.docs {
////                    db.collection(self.appSettings.userID).addDocument(data: ["text": doc.text])
//                }
                self.createNewDocument(text: "")
                NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
            }
        }
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser

        user?.delete { error in
            if error != nil { print("Error deleting user: ",error ?? ""); return}
        }
    }
    
}
