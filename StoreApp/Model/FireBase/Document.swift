//
//  Document.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import Foundation
import UIKit

class Document {
    
    init(category: String, subCategory: String, documentID: String, name: String, price: Int, description: String){
        self.category = category
        self.subCategory = subCategory
        self.documentID = documentID
        self.name = name
        self.price = price
        self.description = description
    }
    
    var category = ""
    var subCategory = ""
    var documentID = ""
    var name = ""
    var price = 0
    var img = UIImage()
    var description = ""
    
    func setImage(image: UIImage) {
        img = image
    }

}
