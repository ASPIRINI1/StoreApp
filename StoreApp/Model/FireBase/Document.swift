//
//  Document.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import Foundation
import UIKit

class Document {
    
    init(documentID: String, name: String, price: Int, description: String){
        self.documentID = documentID
        self.name = name
        self.price = price
//        self.img = img
        self.description = description
    }
    
    var documentID = ""
    var name = ""
    var price = 0
    var img: [UIImage] = []
    var description = ""
    
    func setImage(images:[UIImage]) {
        img = images
    }

}
