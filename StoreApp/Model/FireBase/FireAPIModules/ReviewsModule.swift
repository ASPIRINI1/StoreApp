//
//  ReviewsModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation

extension FireAPI {
    
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
    
}
