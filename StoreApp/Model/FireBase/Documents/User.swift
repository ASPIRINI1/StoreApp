//
//  User.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.05.2022.
//

import Foundation

class User: Codable {
    
    static let shared = User()
    
    private init () {
        
    }
    
    func set(UID: String, email: String, address: String?, fullName: String, phoneNum: Int) {
        
        self.userID = UID
        self.email = email
        self.fullName = fullName
        self.phoneNum = phoneNum
        
        if let address = address {
            self.address = address
        }
        
        AppSettings.shared.user = self
    }
    
    func remove() {
        
        email = String()
        userID = String()
        address = nil
        fullName = String()
        phoneNum = Int()
        AppSettings.shared.user = nil
    }
    
    var email = String()
    var userID = String()
    var address: String? = nil
    var fullName = String()
    var phoneNum = Int()
}
