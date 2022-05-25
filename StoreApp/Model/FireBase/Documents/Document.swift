//
//  Document.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import Foundation
import UIKit

class Document: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ID)
    }
    
    static func == (lhs: Document, rhs: Document) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    
    init(category: String, subCategory: String, documentID: String, name: String, price: Int, description: String){
        self.category = category
        self.subCategory = subCategory
        self.ID = documentID
        self.name = name
        self.price = price
        self.description = description
    }
    
    var category = String()
    var subCategory = String()
    var ID = String()
    var name = String()
    var price = Int()
    var image = UIImage()
    var description = String()

}
