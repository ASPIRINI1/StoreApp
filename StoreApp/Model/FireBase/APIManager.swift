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
    
    private lazy var db = configureFB()
    private lazy var storage = Storage.storage()
    private lazy var storageRef = storage.reference()
    
    init() {
    }
    
    
//    MARK: - Configure DB & get from DB
    
     private func configureFB() -> Firestore{
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    
//    MARK: - Getters/Setters
    
    func getProducts(category: String, subCategoriy: String, completion: @escaping ([Document]) -> () ) {
        
        db.collection("Products").document(category).collection(subCategoriy).getDocuments() { querySnapshot, error in
            
            if let err = error{
                
                print("Error getting documents for category: \(err)")
                NotificationCenter.default.post(name: NSNotification.Name( "DocsNotLoaded"), object: nil)
                
            } else {
                
                var products: [Document] = []
                for document in querySnapshot!.documents{
                    
                    NotificationCenter.default.post(name: NSNotification.Name( "LoadingDocs"), object: nil)
    //                   self.docs.removeAll()
                    
                    products.append(Document(category: category, subCategory: subCategoriy, documentID:document.documentID ,
                                                name: document.get("name") as! String,
                                                price: document.get("price") as! Int,
                                                description: document.get("description") as? String ?? "no description"))
                }
                completion(products)
                NotificationCenter.default.post(name: NSNotification.Name( "DocsLoaded"), object: nil)
            }
            }
    }
    func getDecscription(doc: Document, completion: @escaping (String) -> ()) {
        
        db.collection("Products").document(doc.category).collection(doc.subCategory).document(doc.documentID).getDocument { documentSnapshot, error in
            if error != nil { print("Getting description error: ", error!)}
            
            if documentSnapshot != nil {
                completion(documentSnapshot?.get("decription") as! String)
            }
        }
    }
    
    func getProductImages(doc: Document, completion: @escaping ([UIImage]?) -> ()) {
        
        
        let productsRef = storageRef.child(doc.category + "/" + doc.subCategory).child(doc.documentID)
        var images: [UIImage]? = []
        
        productsRef.listAll(completion: { imageList, error in
            if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
            for image in imageList.items {
                image.getData(maxSize: 1 * 1024 * 1024) { data, error in //??
                    
                    if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
                    
                    if data != nil {
                        images?.append(UIImage(data: data!)!)
                        
                    }
                    if imageList.items.count == images?.count {
                        completion(images)
                    }
                }
            }
            
        })
    }
    
    func getFirstImage(document: Document, completion: @escaping (UIImage) -> ()) {
        
        let productsRef = storageRef.child(document.category + "/" + document.subCategory).child(document.documentID)
        
        productsRef.listAll(completion: { imageList, error in
            if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
            
            if !imageList.items.isEmpty {
                
                imageList.items[0].getData(maxSize: 1 * 1024 * 1024) { data, error in
                    completion(UIImage(data: data!)!)
                }
            }
        })
    }

    
    func getCategories(completion: @escaping ([[String]]) -> ()) {

        var categories: [[String]] = []
        
        storageRef.listAll { storageListResult, err in
            
            if err == nil {
                for category in storageListResult.prefixes {
                    
                    categories.append([category.name])
                    
                    self.storageRef.child(categories.last!.first!).listAll { result, err in
                        if err != nil { print("Error getting SubCategory") ; return }
                        
                        for subCategory in result.prefixes {
                            categories[categories.endIndex-1].append(subCategory.name)
                        }
                        AppSettings.shared.categories = categories
                        completion(AppSettings.shared.categories)
                    }
                }
                
            } else {
                print("Getting category error : ", err!)
            }
        }
    }
    
    func addToCart(document: Document) {
        
        db.collection("Users").document(AppSettings.shared.userID).updateData(
            ["cart" : FieldValue.arrayUnion(
                [document.category + "/" + document.subCategory  + "/" + document.documentID]
            )]) { err in
                
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
    }
    
    func getUserCart(completion: @escaping ([Document]) -> ()) {
        
        if AppSettings.shared.userID != "" {
            
            db.collection("Users").document(AppSettings.shared.userID).getDocument { cartSnapshot, error in
                if error != nil { print("Error getting user cart: ", error!)}
                var cart: [String] = []
                
                if cartSnapshot != nil {
                    cart = cartSnapshot!.get("cart") as! [String]
                    var docs: [Document] = []
//                    let c = cart.first?.firstIndex(of: "/").hashValue
//                    let category = cart.prefix(upTo: c)
//                    let s = cart.lastIndex(of: "/")
//                    let subcategory = cart.suffix(from: s!)
                    
                    for path in cart {
                        self.db.collection("Products").document(path).getDocument { doc, error in
                            
                            if error != nil { print("Error getting docs for user cart: ", error!)}
                            
                            if doc != nil {
                                docs.append(Document(category: category as! String,
                                                     subCategory: subcategory as! String,
                                                     documentID: doc!.documentID,
                                                     name: doc!.get("name") as! String,
                                                     price: doc!.get("price") as! Int,
                                                     description: doc!.get("decription") as! String))
                            }
                            
                            if docs.count == cart.count {
                                completion(docs)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeFromCart(document: Document) {
        
        db.collection("Users").document(AppSettings.shared.userID).updateData(
            ["cart" : FieldValue.arrayRemove([document.category + "/" + document.subCategory  + "/" + document.documentID])]) { err in
                
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
    }


    //    MARK: - Create,Update,Delete documents
    
    private func createNewUserFiles(fullname: String, address: String){
        
        if AppSettings.shared.userID != ""{
            
            let data: [String : Any] = ["fullName": fullname,
                                        "address" : address,
                                        "cart" : [""],
                                        "reviews" : [""]]
            
            db.collection("Users").document(AppSettings.shared.userID).setData(data)
        }
   }
    
    private func deleteUserFiles(){
        
        db.collection("Users").document(AppSettings.shared.userID).delete()
        db.collection("Reviews").document(AppSettings.shared.userID).delete()
    }
    


    
//    MARK: - Registration $ Authorization
    
    func signIn(email: String, password: String, completion: (Bool) -> ()...){
        
        Auth.auth().signIn(withEmail: email, password: password) { [] authResult, error in
            
            if error != nil {
                print("SignIn error")
                completion[0](false)
                
            } else {
                AppSettings.shared.userID = authResult?.user.uid ?? ""
                AppSettings.shared.signedIn = true
                AppSettings.shared.userEmail = email
                completion[0](true)
                
                NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
            }
        }
    }
    
    func signOut(){
        
       do {
           
           try Auth.auth().signOut()
           
       } catch let signOutError as NSError { print("Error signing out: %@", signOutError); return }
        
        AppSettings.shared.signedIn = false
        AppSettings.shared.userEmail = ""
        AppSettings.shared.userID = ""
        
        NotificationCenter.default.post(name: NSNotification.Name("SignedOut"), object: nil)
    }
    
    func registration(email: String, password: String, completion: (Bool) -> ()...){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if  (error != nil){
                print("Registration error:", error!)
                completion[0](false)
                
            } else {
                AppSettings.shared.userID = authResult?.user.uid ?? ""
                AppSettings.shared.userEmail = email
                AppSettings.shared.signedIn = true
                
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
