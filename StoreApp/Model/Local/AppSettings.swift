//
//  UserDefaults.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.03.2022.
//

import Foundation
import CoreLocation

class AppSettings{
    
    let userDefaults = UserDefaults.standard
    static let shared = AppSettings()
    
    private init (){
        
    }
    
    private enum SettingsKeys: String{
        case isSignIn = "signedIn"
        case appTheme = "AppTheme"
        case categories = "categories"
        case user = "user"
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
    
    var user: User? {
        get {
            if let data = userDefaults.value(forKey: SettingsKeys.user.rawValue) as? Data {
              return try? PropertyListDecoder().decode(User.self, from: data)
            }
            return nil
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                userDefaults.set(data, forKey: SettingsKeys.user.rawValue)
            }
            
            if newValue != nil {
                signedIn = true
                
            } else {
                signedIn = false
            }
        }
    }
    
}
