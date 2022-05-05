//
//  Review.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 04.05.2022.
//

import Foundation

class Review {

    init(authorName: String, text: String, mark: Int) {
        self.authorName = authorName
        self.text = text
        self.mark = mark
    }

    var authorName = ""
    var text = ""
    var mark = 0
}


