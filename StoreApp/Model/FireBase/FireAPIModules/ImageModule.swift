//
//  ImageModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.05.2022.
//

import Foundation
import UIKit

extension FireAPI {
    
//    MARK: Images
    
    func getProductImages(doc: Document, completion: @escaping ([UIImage]?) -> ()) {
        
        let productsRef = storageRef.child(doc.category + "/" + doc.subCategory).child(doc.ID)
        var images: [UIImage]? = []
        
        productsRef.listAll(completion: { imageList, error in
            if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
            guard let items = imageList?.items else { return }
            
            for image in items {
                image.getData(maxSize: 1 * 1024 * 1024) { data, error in //!!
                    
                    if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
                    
                    if data != nil {
                        images?.append(UIImage(data: data!) ?? UIImage(named: "NoImageIcon")!)
                        
                    }
                    if items.count == images?.count {
                        completion(images)
                    }
                }
            }
        })
    }
    
    func getFirstImage(document: Document, completion: @escaping (UIImage) -> ()) {
        
        let productsRef = storageRef.child(document.category + "/" + document.subCategory).child(document.ID)
        
        productsRef.listAll(completion: { imageList, error in
            
            if (error != nil) { print("Error getting image for product: ", error ?? ""); return }
            guard let images = imageList?.items else { return }
            if images.isEmpty { return }
                
            imageList?.items[0].getData(maxSize: 1 * 1024 * 1024) { data, error in
                
                if let error = error { print("Error getting first image: ",error); return }
                guard let data = data else { return }
                
                completion((UIImage(data: data) ?? UIImage(named: "NoImageIcon"))!)
            }
        })
    }
}
