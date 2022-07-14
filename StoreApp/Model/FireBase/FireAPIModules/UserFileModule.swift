//
//  UserModule.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 24.05.2022.
//

import Foundation

extension FireAPI {
     
    //    MARK: - Create,Update,Delete documents
    
    func createNewUserFiles(uid: String,fullname: String, address: String, phoneNum: Int, completion: @escaping () -> ()) {
            
        let data: [String : Any] = ["fullName": fullname,
                                    "address" : address,
                                    "phoneNum" : phoneNum,
                                    "cart" : []]
        
        db.collection(RootCollections.users.rawValue).document(uid).setData(data) { error in
            if error != nil { print("Error creating user files: ", error!); return }
            completion()
        }
   }
    
    func deleteUserFiles() {
        guard let userID = AppSettings.shared.user?.userID else { return }
        db.collection(RootCollections.users.rawValue).document(userID).delete()
    }
}
