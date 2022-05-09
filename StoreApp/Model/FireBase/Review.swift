//
//  Review.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 04.05.2022.
//

import Foundation

class Review {

    init(ID: String, authorID: String, authorName: String, text: String, mark: Int) {
        self.reviewID = ID
        self.authorID = authorID
        self.authorName = authorName
        self.text = text
        self.mark = mark
    }

    var reviewID = ""
    var authorID = ""
    var authorName = ""
    var text = ""
    var mark = 0
    
}


