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
    private var appSettings = AppSettings()
    private var categories: [[String]] = []
    
    init() {
//        getDocuments()
    }
    
    
//    MARK: - Configure DB & get from DB
    
     private func configureFB() -> Firestore{
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
//    private func getDocuments(){
//
////        if appSettings.userID != ""{
//
//            let db = configureFB()
//        db.collection("Products").getDocuments()  { (querySnapshot, err) in
//
//                 if let err = err {
//                     print("Error getting documents: \(err)")
//                 } else {
//                     for document in querySnapshot!.documents {
//                         NotificationCenter.default.post(name: NSNotification.Name("LoadingNotes"), object: nil)
//
//                     }
//                     NotificationCenter.default.post(name: NSNotification.Name("NotesLoaded"), object: nil)
//                 }
//             }
////        }
//     }
    
//    MARK: - Getters/Setters
    
    func getProductsForCategory(category: String, subCategoriy: String, completion: @escaping ([Document]) -> () ) {
        
        let db = configureFB()
        db.collection("Products").document(category).collection(subCategoriy).getDocuments() { querySnapshot, error in
            
            if let err = error{
                
                print("Error getting documents for category: \(err)")
                NotificationCenter.default.post(name: NSNotification.Name( "DocsNotLoaded"), object: nil)
                
            } else {
                
                var products: [Document] = []
                for document in querySnapshot!.documents{
                    
                    NotificationCenter.default.post(name: NSNotification.Name( "LoadingDocs"), object: nil)
//                    self.docs.removeAll()
                    
                    products.append(Document(documentID: document.documentID ,
                                             name: document.get("name") as! String,
                                             price: document.get("price") as! Int,
                                             description: document.get("description") as? String ?? "no description"))
                }
                completion(products)
                NotificationCenter.default.post(name: NSNotification.Name( "DocsLoaded"), object: nil)
            }
         }
    }
    
    func getImageForProductIntoMemory(docID: String ,category: String, subCategory: String, completion: @escaping ([UIImage]?) -> ()) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let productsRef = storageRef.child(category + "/" + subCategory).child(docID)
        var images: [UIImage]? = []
        
        productsRef.listAll(completion: { imageList, error in
            if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
            
            for image in imageList.items {
                image.getData(maxSize: 1 * 1024 * 1024) { data, error in //??
                    
                    if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
                    
                    if data != nil {
                        images?.append(UIImage(data: data!)!)
                        completion(images)
                    }
                }
            }
        })
    }
    
    func getOneImage(category: String, subCategory: String, docID: String, completion: @escaping (UIImage) -> ()) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let productsRef = storageRef.child(category + "/" + subCategory).child(docID)
        var image = UIImage()
        
        productsRef.listAll(completion: { imageList, error in
            if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
            
            imageList.items[0].getData(maxSize: 99 * 1024 * 1024) { data, error in
                image = UIImage(data: data!)!
                completion(image)
            }
        })
    }

    
    func getCategories(completion: @escaping ([[String]]) -> ()) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        storageRef.listAll { storageListResult, err in
            
            if err == nil {
                for category in storageListResult.prefixes {
                    
                    self.categories.append([category.name])
                    
                    storageRef.child(self.categories.last!.first!).listAll { result, err in
                        if err != nil { print("Error getting SubCategory") ; return }
                        
                        for subCategory in result.prefixes {
                            self.categories[self.categories.endIndex-1].append(subCategory.name)
                            self.appSettings.categories = self.categories
                        }
                        completion(self.appSettings.categories)
                    }
                }
                
            } else {
                print("Getting category error : ", err!)
            }
        }
    }
    
    func getUserCart() {
        
        if appSettings.userID != "" {
            let db = configureFB()
            
            db.collection("Users").document(appSettings.userID).getDocument { documentSnapshot, error in
                if error != nil { print("Error getting user cart: ", error!)}
                if documentSnapshot != nil {
                    self.appSettings.userCart = documentSnapshot?.get("cart") as! [String]
                }
            }
        }
    }
    
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

    //    MARK: - Create,Update,Delete documents
    
    private func createNewUserFiles(fullname: String, address: String){
        
        let db = configureFB()
        if appSettings.userID != ""{
            
            let data: [String : Any] = ["fullName": fullname,
                                        "address" : address,
                                        "cart" : [""],
                                        "reviews" : [""]]
            
            db.collection("Users").document(appSettings.userID).setData(data)
        }
   }
    
    private func deleteUserFiles(){
        let db = configureFB()
        db.collection("Users").document(appSettings.userID).delete()
        db.collection("Reviews").document(appSettings.userID).delete()
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
        
        self.appSettings.signedIn = false
        self.appSettings.userEmail = ""
        self.appSettings.userID = ""
        
        NotificationCenter.default.post(name: NSNotification.Name("SignedOut"), object: nil)
    }
    
    func registration(email: String, password: String, completion: (Bool) -> ()...){
        
        let firebaseAuth = Auth.auth()
        
        firebaseAuth.createUser(withEmail: email, password: password) { authResult, error in
            if  (error != nil){
                print("Registration error:", error!)
                completion[0](false)
                
            } else {
                self.appSettings.userID = authResult?.user.uid ?? ""
                self.appSettings.userEmail = email
                self.appSettings.signedIn = true
                
                completion[0](true)

                self.createNewUserFiles(fullname: "fullname", address: "address")
                
                NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
            }
        }
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser

        user?.delete { error in
            if error != nil { print("Error deleting user: ",error ?? ""); return}
        }
        deleteUserFiles()
        signOut()
    }
    
}
