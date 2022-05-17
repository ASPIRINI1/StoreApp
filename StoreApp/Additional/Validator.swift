//
//  Validator.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 05.04.2022.
//

import Foundation

class Validator {
    
    static let shared = Validator()
    
    private init() {
        
    }

    func userDataIsCurrect(email: String?, pass: String?) -> Bool{
        
        if email != nil && pass != nil {
            if email!.isValidEmail(){
                if pass!.isValidPass() {
                    return true
                }
            }
        }
        return false
    }
}

// Email checking
extension String {
    
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\\.[a-zA-Z.]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPass() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z0-9._-]{8,20}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidFullName() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[a-zA-Zа-яА-Я-]{8,60}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidCardNum() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[0-9]{16,16}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidProneNum() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[0-9]{10,12}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

