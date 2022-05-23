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
    lazy var db = configureFB()
    lazy var storage = Storage.storage()
    lazy var storageRef = storage.reference()
    lazy var docSnapshot: QueryDocumentSnapshot? = nil
    lazy var currectUser = Auth.auth().currentUser
    
     enum RootCollections: String {
        case products = "Products"
        case users = "Users"
        case reviews = "Reviews"
    }
    
    private init() {
    }
    
    
//    MARK: - Configure DB

     private func configureFB() -> Firestore{
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
      
    
// MARK: Additional
    
    func getProductCategory(path: String) -> (category:String, subCategory:String) {
        
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

    
//    MARK: Categories
    
    func getCategories(completion: @escaping ([[String]]) -> ()) {

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
}
