//
//  FireAPIProductModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation

extension FireAPI {
    
//    MARK: Products
        
    func getProducts(category: String, subCategoriy: String, completion: @escaping ([Document]) -> () ) {
        
        var query =  db.collection(RootCollections.products.rawValue).document(category).collection(subCategoriy).limit(to: 10)
        
        if let docSnapshot = docSnapshot {
            query = query.start(afterDocument: docSnapshot)
        }
        
        query.getDocuments() { querySnapshot, error in

            if let error = error {
                print("Error getting documents for category: \(error)")
                NotificationCenter.default.post(name: NSNotification.Name( "DocsNotLoaded"), object: nil)
            }

            guard let documents = querySnapshot?.documents else { return }
            self.docSnapshot = documents.last
            var products: [Document] = []
            
            NotificationCenter.default.post(name: NSNotification.Name( "LoadingDocs"), object: nil)
            
            for document in documents {
                products.append(Document(category: category,
                                            subCategory: subCategoriy,
                                            documentID: document.documentID,
                                            name: document.get("name") as? String ?? "Error name",
                                            price: document.get("price") as? Int ?? 0,
                                            description: document.get("decription") as? String ?? "no description"))
            }
            
            completion(products)
            NotificationCenter.default.post(name: NSNotification.Name( "DocsLoaded"), object: nil)
        }
    }
    
    func getRandomProducts(countForCategory: Int, completion: @escaping ([Document]) -> ()) {
        
        getCategories { [self] categories in

            var subCategoriesCount = 0
            for category in categories {
                subCategoriesCount += category.count-1
            }
            
            NotificationCenter.default.post(name: NSNotification.Name( "LoadingDocs"), object: nil)
            
            for category in categories {
                for subCategory in category {
                    
                    if subCategory == category.first { continue }
//
                        var query =  self.db.collection(RootCollections.products.rawValue).document(category.first!).collection(subCategory).limit(to: countForCategory)

                        if let docSnapshot = self.docSnapshot {
                            query = query.start(afterDocument: docSnapshot)
                        }

                        query.getDocuments { querySnapshot, error in

                            if let error = error { print("Error getting random doc: ", error); return }
                            guard let documents = querySnapshot?.documents else { return }
                            if documents.isEmpty { return }
                            self.docSnapshot = documents.last
                            var docs: [Document] = []

                            for doc in documents {
                                docs.append(Document(category: category.first!,
                                                    subCategory: subCategory,
                                                    documentID: doc.documentID,
                                                    name: doc.get("name") as? String ?? "Error name",
                                                    price: doc.get("price") as? Int ?? 0,
                                                    description: doc.get("decription") as? String ?? "No description"))
                            }

                            if docs.count == (countForCategory * subCategoriesCount) {
                                completion(docs)
                                NotificationCenter.default.post(name: NSNotification.Name( "DocsLoaded"), object: nil)
                            }

                        }
//                    getProducts(category: category.first!, subCategoriy: subCategory) { documents in
//                        completion(documents)
//                    }
                }
            }
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
                    if let error = error { print("Error searching product: ", error) }
                    guard let documents = querySnapshot?.documents else { return }
      
                    for doc in documents {
                        docs.append(Document(category: category.first ?? "Error",
                                            subCategory: subCategory,
                                            documentID: doc.documentID,
                                            name: doc.get("name") as? String ?? "Error name",
                                            price: doc.get("price") as? Int ?? 0,
                                            description: doc.get("decription") as? String ?? ""))
                    }
                    
                    if docs.count == querySnapshot?.documents.count {
                        completion(docs)
                    }
                }
            }
        }
        
       
    }
    
    func getDecscription(doc: Document, completion: @escaping (String) -> ()) {
        
        db.collection(RootCollections.products.rawValue).document(doc.category).collection(doc.subCategory).document(doc.ID).getDocument { documentSnapshot, error in
            
            if let error = error { print("Getting description error: ", error)}
            guard let description = documentSnapshot?.get("decription") as? String else { return }
            completion(description)
        }
    }
    
    
}
