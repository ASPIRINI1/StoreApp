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
    
//    var f = FireAPIUserAccount()
    private lazy var db = configureFB()
    private lazy var storage = Storage.storage()
    private lazy var storageRef = storage.reference()
    private lazy var docSnapshot: QueryDocumentSnapshot? = nil
    
    private enum RootCollections: String {
        case products = "Products"
        case users = "Users"
        case reviews = "Reviews"
    }
    
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
        
        var query =  db.collection(RootCollections.products.rawValue).document(category).collection(subCategoriy).limit(to: 10)
        
        if let docSnapshot = docSnapshot {
            query = query.start(afterDocument: docSnapshot)
        }
        
        query.getDocuments() { querySnapshot, error in

            if let err = error{
                print("Error getting documents for category: \(err)")
                NotificationCenter.default.post(name: NSNotification.Name( "DocsNotLoaded"), object: nil)

            } else {


                self.docSnapshot = querySnapshot!.documents.last
                var products: [Document] = []
                for document in querySnapshot!.documents{

                    NotificationCenter.default.post(name: NSNotification.Name( "LoadingDocs"), object: nil)

                    products.append(Document(category: category,
                                             subCategory: subCategoriy,
                                             documentID:document.documentID,
                                             name: document.get("name") as! String,
                                             price: document.get("price") as! Int,
                                             description: document.get("decription") as? String ?? "no description"))
                }
                completion(products)
                NotificationCenter.default.post(name: NSNotification.Name( "DocsLoaded"), object: nil)
            }
        }
    }
    
    func getRandomProducts(countForCategory: Int, completion: @escaping ([Document]) -> ()) {
        
        getCategories { categories in

            var subCategoriesCount = 0
            for category in categories {
                subCategoriesCount += category.count-1
            }
            
            var docs: [Document] = []
            for category in categories {
                for subCategory in category {
                    
                    if subCategory == category.first { continue }
                    
                    var query =  self.db.collection(RootCollections.products.rawValue).document(category.first!).collection(subCategory).limit(to: countForCategory)
                    
                    if let docSnapshot = self.docSnapshot {
                        query = query.start(afterDocument: docSnapshot)
                    }
                    
                    query.getDocuments { querySnapshot, error in
                        
                        if let error = error { print("Error getting random doc: ", error); return }

                        NotificationCenter.default.post(name: NSNotification.Name( "LoadingDocs"), object: nil)

                        if querySnapshot != nil {
                            
                            self.docSnapshot = querySnapshot!.documents.last
                            for doc in querySnapshot!.documents {

                                docs.append(Document(category: category.first!,
                                                     subCategory: subCategory,
                                                     documentID: doc.documentID,
                                                     name: doc.get("name") as! String,
                                                     price: doc.get("price") as! Int,
                                                     description: doc.get("decription") as! String))
                            }
                        }

                        if docs.count == (countForCategory * subCategoriesCount) {
                            completion(docs)
                            NotificationCenter.default.post(name: NSNotification.Name( "DocsLoaded"), object: nil)
                        }
                    }
                }
            }
        }

    }
    
    func getDocumentsCountForCategory(category: String, subCategory: String) {
        
        db.collection(RootCollections.products.rawValue).document(category).collection(subCategory).getDocuments { querySnapshot, error in
            print(querySnapshot?.documents.count)
        }
    }
    
    func findProduct(name: String, completion: @escaping ([Document]) -> ()) {
        
        for category in AppSettings.shared.categories {
            
            var docs = [Document]()
            
            for subCategory in category {
                if subCategory == category.first {
                    continue
                }
                
                db.collection(RootCollections.products.rawValue).document(category.first!).collection(subCategory).whereField("name",isGreaterThanOrEqualTo: name).order(by: "name").getDocuments { querySnapshot, error in
                    if let error = error { print("Error searching product: ", error)}
                    
                    
                    if querySnapshot != nil {
                    
                        for doc in querySnapshot!.documents {
                            docs.append(Document(category: category.first!,
                                                 subCategory: subCategory,
                                                 documentID: doc.documentID,
                                                 name: doc.get("name") as! String,
                                                 price: doc.get("price") as! Int,
                                                 description: doc.get("decription") as! String))
                        }
                    }
                    
                    if docs.count == querySnapshot?.documents.count {
                        completion(docs)
                    }
                }
            }
        }
        
       
    }
    
    func getDecscription(doc: Document, completion: @escaping (String) -> ()) {
        
        db.collection(RootCollections.products.rawValue).document(doc.category).collection(doc.subCategory).document(doc.documentID).getDocument { documentSnapshot, error in
            if let error = error { print("Getting description error: ", error)}
            
            if documentSnapshot != nil {
                completion(documentSnapshot?.get("decription") as! String)
            }
        }
    }
    
    private func getProductCategory(path: String) -> (category:String, subCategory:String) {
        
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
        
        return (category, subCategory)
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
                    if let error = error { print("Error getting first image: ",error); return }
                    
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
        
        db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).updateData(
            ["cart" : FieldValue.arrayUnion( [document.category + "/" + document.subCategory  + "/" + document.documentID]
            )]) { err in
                
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
    }
    
    func getUserCart(completion: @escaping ([Document]) -> ()) {
        
        if AppSettings.shared.userID != "" {
            
            db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).getDocument { cartSnapshot, error in
                if let error = error { print("Error getting user cart: ", error)}
                var cart: [String] = []
                
                if cartSnapshot != nil {
                    cart = cartSnapshot!.get("cart") as! [String]
                    var docs: [Document] = []
                   
                    
                    for path in cart {
                        self.db.collection(RootCollections.products.rawValue).document(path).getDocument { doc, error in
                            
                            if let error = error { print("Error getting docs for user cart: ", error)}
                            
                            if doc != nil {
                                
                                let cat = self.getProductCategory(path: path)
                                
                                docs.append(Document(category: cat.category,
                                                     subCategory: cat.subCategory,
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
        
        db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).updateData(
            ["cart" : FieldValue.arrayRemove([document.category + "/" + document.subCategory  + "/" + document.documentID])]) { err in
                
                if let err = err {
                    print("Error writing document: \(err)")
                }
            }
    }
    
    func isInCart(document: Document, completion: @escaping (Bool) -> ()) {
        
        db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).getDocument { documentSnapshot, error in
            
            if let error = error {
                print("Error writing document: \(error)")
                completion(false)
            }
            
            if documentSnapshot != nil {
                let userCart = documentSnapshot?.get("cart") as! [String]
                
                for userCart in userCart {
                    if userCart.contains(document.documentID) {
                        completion(true)
                        
                    } else {
                        completion(false)
                    }
                }
            }
        }
        
    }


    //    MARK: - Create,Update,Delete documents
    
    private func createNewUserFiles(fullname: String, address: String, phoneNum: Int) {
        
        if AppSettings.shared.signedIn {
            let data: [String : Any] = ["fullName": fullname,
                                        "address" : address,
                                        "phoneNum" : phoneNum,
                                        "cart" : []]
            
            db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).setData(data)
        }
   }
    
    private func deleteUserFiles(){

        db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).delete()
        db.collection(RootCollections.reviews.rawValue).document(AppSettings.shared.userID).delete()
    }
    
//MARK: Review
    
    func addReview(documentID: String ,text: String, mark: Int) {
        
        db.collection(RootCollections.reviews.rawValue).addDocument(data: ["authorID" : AppSettings.shared.userID,
                                                    "product" : documentID,
                                                    "authorName" : AppSettings.shared.userFullName,
                                                    "text" : text,
                                                    "mark" : mark])
    }
    
    func getReviews(documentID: String, completion: @escaping (_ reviews: [Review]) -> ()) {
        
        db.collection(RootCollections.reviews.rawValue).whereField("product", isEqualTo: documentID).getDocuments { querySnapshot, error in
            if let error = error { print("Error getting reviews: ", error); return }
            
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
        
        db.collection(RootCollections.reviews.rawValue).document(reviewID).delete()
    }

    
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
    
    func deleteAccount() {
        
        let user = Auth.auth().currentUser

        user?.delete { error in
            if let error = error { print("Error deleting user: ",error); return}
        }
        deleteUserFiles()
        signOut()
    }
    
//    MARK: Change user
    
    func changeUser(email: String, completion: @escaping (Bool) -> ()) {
        
        if !email.isEmpty {
            Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email, completion: { error in
                
                if let error = error {
                    print("Error changing user email: ", error)
                    completion(false)
                    
                } else {
                    AppSettings.shared.userEmail = email
                    completion(true)
                }
            })
        }
    }
    
    func changeUser(password: String, completion: @escaping (Bool) -> ()) {
        
        if !password.isEmpty {
            Auth.auth().currentUser?.updatePassword(to: password, completion: { error in
                
                if let error = error {
                    print("Error changing user password: ", error)
                    completion(false)

                } else {
                    completion(true)
                }
            })
        }
    }
    
    func changeUser(address: String, completion: @escaping (Bool) -> ()) {
        
        if !address.isEmpty {
            db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).updateData(["address" : address]) { error in
                
                if let error = error {
                    print("Error changing user address: ", error)
                    completion(false)
                    
                } else {
                    AppSettings.shared.userAddress = address
                    completion(true)
                }
            }
        }
    }
    
    func changeUser(phoneNum: Int, completion: @escaping (Bool) -> ()) {
        
        db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).updateData(["phoneNum" : phoneNum]) { error in
            
            if let error = error {
                print("Error changing phone num: ",error)
                completion(false)
                
            } else {
                AppSettings.shared.userPhoneNum = phoneNum
                completion(true)
            }
            
        }
    }
}
