//
//  UserDefaults.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import Foundation

class AppSettings{
    
    let userDefaults = UserDefaults.standard
    
    private enum SettingsKeys: String{
        case userEmail = "userEmail"
        case appTheme = "AppTheme"
        case isSignIn = "signedIn"
        case userAddress = "userAddress"
        case userID = "userID"
        case categories = "categories"
    }
    
    var userEmail: String{
        get{
            if let data = userDefaults.string(forKey: SettingsKeys.userEmail.rawValue){
                return data
            }else{
                return ""
            }
        }
        set{
            userDefaults.set(newValue, forKey: SettingsKeys.userEmail.rawValue)
        }
    }
    
    var signedIn: Bool{
        get{
            return userDefaults.bool(forKey: SettingsKeys.isSignIn.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: SettingsKeys.isSignIn.rawValue)
        }
    }
    
    var appTheme: Int {
        get{
            return userDefaults.integer(forKey: SettingsKeys.appTheme.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: SettingsKeys.appTheme.rawValue)
        }
    }
//    var language: String{
//        get{
//            if let data = userDefaults.string(forKey: SettingsKeys.language.rawValue){
//                return data
//            } else {
//                return ""
//            }
//        }
//        set{
//            if newValue != ""{
//                userDefaults.set(newValue, forKey: SettingsKeys.language.rawValue)
//            }
//        }
//    }
    
    var userID: String{
        get{
            return userDefaults.string(forKey: SettingsKeys.userID.rawValue) ?? ""
        }
        set{
            userDefaults.set(newValue, forKey: SettingsKeys.userID.rawValue)
        }
    }
    
    var userAdress: String{
        get {
            return userDefaults.string(forKey: SettingsKeys.userAddress.rawValue ) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: SettingsKeys.userAddress.rawValue)
        }
    }
    
    var categories: [[String]]{
        get {
            if userDefaults.value(forKey: SettingsKeys.categories.rawValue) != nil { // ??
                
                return userDefaults.value(forKey: SettingsKeys.categories.rawValue) as! [[String]]
            } else {
                return [[""]]
            }
        }
        set {
            userDefaults.set(newValue, forKey: SettingsKeys.categories.rawValue)
        }
    }
    
}
