//
//  UserModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.05.2022.
//

import Foundation

extension FireAPI {
     
    //    MARK: - Create,Update,Delete documents
    
    func createNewUserFiles(fullname: String, address: String, phoneNum: Int) {
        
        if AppSettings.shared.signedIn { }
        
        
        if let userID = AppSettings.shared.user?.userID {
            
            let data: [String : Any] = ["fullName": fullname,
                                        "address" : address,
                                        "phoneNum" : phoneNum,
                                        "cart" : []]
            
            db.collection(RootCollections.users.rawValue).document(userID).setData(data)
        }
   }
    
    func deleteUserFiles(){
        
        if let userID = AppSettings.shared.user?.userID {
            
            db.collection(RootCollections.users.rawValue).document(userID).delete()
            db.collection(RootCollections.reviews.rawValue).document(userID).delete()
        }
        
    }
}
