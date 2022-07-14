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
            
            if !AppSettings.shared.signedIn { return }
            
            db.collection(RootCollections.reviews.rawValue).addDocument(data: [
                "authorID" :AppSettings.shared.user!.userID,
                "product" : documentID,
                "authorName" : AppSettings.shared.user!.fullName,
                "text" : text,
                "mark" : mark])
        }
        
        func getReviews(documentID: String, completion: @escaping (_ reviews: [Review]) -> ()) {
            
            db.collection(RootCollections.reviews.rawValue).whereField("product", isEqualTo: documentID).getDocuments { querySnapshot, error in
                
                if let error = error { print("Error getting reviews: ", error); return }
                guard let documents = querySnapshot?.documents else { return }
                var reviews: [Review] = []
                
                for doc in documents {
                    
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
        
        func removeReview(reviewID: String) {
            db.collection(RootCollections.reviews.rawValue).document(reviewID).delete()
        }
    
}
