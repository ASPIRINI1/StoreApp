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
        case userID = "userID"
        case userEmail = "userEmail"
        case userFullName = "userFullName"
        case userAddress = "userAddress"
        case userPhoneNum = "userPhoneNum"
        case isSignIn = "signedIn"
        case appTheme = "AppTheme"
        case categories = "categories"
//        case shopList = "shopList"
    }
    
    
    var userID: String{
        get{
            return userDefaults.string(forKey: SettingsKeys.userID.rawValue) ?? ""
        }
        set{
            userDefaults.set(newValue, forKey: SettingsKeys.userID.rawValue)
        }
    }
    
    var userEmail: String {
        get{
                return userDefaults.string(forKey: SettingsKeys.userEmail.rawValue) ?? ""
        }
        set{
            userDefaults.set(newValue, forKey: SettingsKeys.userEmail.rawValue)
        }
    }
    
    var userFullName: String {
        get {
            return userDefaults.string(forKey: SettingsKeys.userFullName.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: SettingsKeys.userFullName.rawValue)
        }
    }
    
    var userAddress: String{
        get {
            return userDefaults.string(forKey: SettingsKeys.userAddress.rawValue ) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: SettingsKeys.userAddress.rawValue)
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
    
    var userPhoneNum: Int {
        get {
            return userDefaults.value(forKey: SettingsKeys.userPhoneNum.rawValue) as! Int
        }
        set {
            userDefaults.set(newValue, forKey: SettingsKeys.userPhoneNum.rawValue)
        }
    }
    
//    var shopList: [CLLocation]{
//        get {
//            return userDefaults.value(forKey: SettingsKeys.shopList.rawValue) as! [CLLocation]
//        }
//        set {
//            userDefaults.set(newValue, forKey: SettingsKeys.shopList.rawValue)
//        }
//    }
    
}
