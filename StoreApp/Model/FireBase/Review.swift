//
//  Review.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 04.05.2022.
//

import Foundation

class Review {

    init(text: String, mark: Int) {
        self.authorID = AppSettings.shared.userID
        self.authorName = AppSettings.shared.userFullName
        self.text = text
        self.mark = mark
    }

    var authorID = ""
    var authorName = ""
    var text = ""
    var mark = 0
    
    func setAuthor(ID: String, name: String) {
        self.authorID = ID
        self.authorName = name
    }
}


