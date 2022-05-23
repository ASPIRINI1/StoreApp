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
        
        if AppSettings.shared.signedIn {
            let data: [String : Any] = ["fullName": fullname,
                                        "address" : address,
                                        "phoneNum" : phoneNum,
                                        "cart" : []]
            
            db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).setData(data)
        }
   }
    
    func deleteUserFiles(){

        db.collection(RootCollections.users.rawValue).document(AppSettings.shared.userID).delete()
        db.collection(RootCollections.reviews.rawValue).document(AppSettings.shared.userID).delete()
    }
}
