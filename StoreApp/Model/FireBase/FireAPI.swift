//
//  FireAPI.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import Foundation
import Firebase
//import GoogleSignIn

class FireAPI {
    
    //    MARK: - Property
    
    static let shared = FireAPI()
    
    private lazy var db = configureFB()
    private lazy var storage = Storage.storage()
    private lazy var storageRef = storage.reference()
    
    private init() {
    }
    
    
//    MARK: - Configure DB & get from DB
    
     private func configureFB() -> Firestore{
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    
//    MARK: - Getters
    
//    MARK: Products
    
    func getProducts(category: String, subCategoriy: String, completion: @escaping ([Document]) -> () ) {
        
        db.collection("Products").document(category).collection(subCategoriy).getDocuments() { querySnapshot, error in
            
            if let err = error{
                
                print("Error getting documents for category: \(err)")
                NotificationCenter.default.post(name: NSNotification.Name( "DocsNotLoaded"), object: nil)
                
            } else {
                
                var products: [Document] = []
                for document in querySnapshot!.documents{
                    
                    NotificationCenter.default.post(name: NSNotification.Name( "LoadingDocs"), object: nil)
                    
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
    
    func getRandomProducts(count: Int,completion: @escaping ([Document]) -> ()) {
        
        getCategories { categories in
            
//            var docCount = -categories.count
//
//            for category in categories {
//                docCount += category.count
//            }
            
            var docs: [Document] = []
            for category in categories {
                for subCategory in category {
                    
                    if subCategory == category.first { continue }
                    
                    self.db.collection("Products").document(category.first!).collection(subCategory).limit(to: 2).getDocuments { querySnapshot, error in
                        
                        if error != nil { print("Error getting random doc: ", error!); return }
                        
                        
                        if querySnapshot != nil {
                            
                            for doc in querySnapshot!.documents {
                                print(doc.documentID)
                                docs.append(Document(category: category.first!,
                                                     subCategory: subCategory,
                                                     documentID: doc.documentID,
                                                     name: doc.get("name") as! String,
                                                     price: doc.get("price") as! Int,
                                                     description: doc.get("decription") as! String))
                            }
                        }
                        
                        if docs.count == count {
                            completion(docs)
                        }
                    }
                }
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
    
//    MARK: Images
    
    func getProductImages(doc: Document, completion: @escaping ([UIImage]?) -> ()) {
        
        let productsRef = storageRef.child(doc.category + "/" + doc.subCategory).child(doc.documentID)
        var images: [UIImage]? = []
        
        
        productsRef.listAll(completion: { imageList, error in
            if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
            for image in imageList.items {
                image.getData(maxSize: 1 * 1024 * 1024) { data, error in //??
                    
                    if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
                    
                    if data != nil {
                        images?.append(UIImage(data: data!) ?? UIImage(named: "NoImageIcon")!)
                        
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
                    if error != nil { print("Error getting first image: ",error!); return }
                    
                    if data != nil {
                        completion((UIImage(data: data!) ?? UIImage(named: "NoImageIcon"))!)
                    }
                }
            }
        })
    }

    
//    MARK: Categories
    
    private func getCategories(completion: @escaping ([[String]]) -> ()) {

        var categories: [[String]] = []

        storageRef.listAll { storageListResult, err in

            if err == nil {
                for category in storageListResult.prefixes {
                    
                    self.storageRef.child(category.name).listAll { result, err in
                        if err != nil { print("Error getting SubCategory") ; return }
                        
                        categories.append([category.name])

                        for subCategory in result.prefixes {
                            categories[categories.endIndex-1].append(subCategory.name)
                        }
                        
                        if categories.count == storageListResult.prefixes.count {
                            AppSettings.shared.categories = categories
                            completion(AppSettings.shared.categories)
                        }
                    }
                    
                }

            } else {
                print("Getting category error : ", err!)
            }
        }
        
    }
    
//    MARK: Cart
    
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
                   
                    
                    for path in cart {
                        self.db.collection("Products").document(path).getDocument { doc, error in
                            
                            if error != nil { print("Error getting docs for user cart: ", error!)}
                            
                            if doc != nil {
                                
                                //getting category
                                var category = ""
                                var subCategory = ""
                                
                                if var stringIndex = path.firstIndex(of: "/") {
                                    category = String(path.prefix(upTo: stringIndex))
                                    var sub = path.suffix(from: stringIndex)
                                    sub.removeFirst()
                                    
                                    if let subU = sub.firstIndex(of: "/") {
                                        stringIndex = subU
                                        subCategory = String(sub.prefix(upTo: stringIndex))
                                    }
                                }
                                
                                docs.append(Document(category: category,
                                                     subCategory: subCategory,
                                                     documentID: doc!.documentID,
                                                     name: doc!.get("name") as! String,
                                                     price: doc!.get("price") as! Int,
                                                     description: ""))
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
    
    private func createNewUserFiles(fullname: String, address: String) {
        
        if AppSettings.shared.signedIn {
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
    
//MARK: Review
    
    func addReview(documentID: String ,text: String, mark: Int) {
        
        db.collection("Reviews").addDocument(data: ["authorID" : AppSettings.shared.userID,
                                                    "product" : documentID,
                                                    "authorName" : AppSettings.shared.userFullName,
                                                    "text" : text,
                                                    "mark" : mark])
    }
    
    func getReviews(documentID: String, completion: @escaping (_ reviews: [Review]) -> ()) {
        
        db.collection("Reviews").whereField("product", isEqualTo: documentID).getDocuments { querySnapshot, error in
            if error != nil { print("Error getting reviews: ", error!); return }
            
            if querySnapshot != nil {
                
                var reviews: [Review] = []
                
                for doc in querySnapshot!.documents {
                    
                    reviews.append(Review(ID: doc.documentID,
                                          authorID: doc.get("authorID") as! String,
                                          authorName: doc.get("authorName") as! String,
                                          text: doc.get("text") as! String,
                                          mark: doc.get("mark") as! Int))
                }
                
                if reviews.count == querySnapshot?.documents.count {
                    completion(reviews)
                }
                
            }
        }
    }
    
    func removeReview(reviewID: String) {
        
        db.collection("Reviews").document(reviewID).delete()
    }

    
//    MARK: - Registration $ Authorization
    
    func signIn(email: String, password: String, completion: (Bool) -> ()...){
        
        Auth.auth().signIn(withEmail: email, password: password) { [] authResult, error in
            
            if error != nil {
                print("SignIn error")
                completion[0](false)
                
            } else {
                
                self.setUser(userID: authResult?.user.uid, email: email)
                completion[0](true)
                
                self.db.collection("Users").document(AppSettings.shared.userID).getDocument { documentSnapshot, error in
                    if error != nil { print("Error getting user data: ", error!); return }
                    
                    if documentSnapshot != nil {
                        AppSettings.shared.userFullName = documentSnapshot?.get("fullName") as! String
                        AppSettings.shared.userAdress = documentSnapshot?.get("address") as! String
                    }
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("SignedIn"), object: nil)
            }
        }
    }
    
    private func setUser(userID: String?, email: String) {
        
        if userID != nil {
            AppSettings.shared.signedIn = true
            AppSettings.shared.userID = userID!
            AppSettings.shared.userEmail = email
            
            db.collection("Users").document(AppSettings.shared.userID).getDocument { documentSnapshot, error in
                if error != nil { print("Error getting user data: ", error!); return }
                
                if documentSnapshot != nil {
                    AppSettings.shared.userFullName = documentSnapshot?.get("fullName") as! String
                    AppSettings.shared.userAdress = documentSnapshot?.get("address") as! String
                }
            }
            
        } else {
            
            AppSettings.shared.signedIn = false
            AppSettings.shared.userEmail = ""
            AppSettings.shared.userID = ""
            AppSettings.shared.userAdress = ""
            AppSettings.shared.userFullName = ""
        }
    }
    
    func signOut(){
        
       do {
           try Auth.auth().signOut()
           
       } catch let signOutError as NSError { print("Error signing out: %@", signOutError); return }
        
        setUser(userID: nil, email: "")
        
        NotificationCenter.default.post(name: NSNotification.Name("SignedOut"), object: nil)
    }
    
    func registration(email: String, password: String, userName: String, adress: String, completion: (Bool) -> ()...){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if  (error != nil){
                print("Registration error:", error!)
                completion[0](false)
                
            } else {
                
                completion[0](true)

                self.createNewUserFiles(fullname: userName, address: adress)
                AppSettings.shared.userFullName = userName
                AppSettings.shared.userAdress = adress
                
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
