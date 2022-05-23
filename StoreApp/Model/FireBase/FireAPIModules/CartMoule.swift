//
//  FireAPICartMoule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation
import Firebase

extension FireAPI {
    
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

}