//
//  UserDataChangeActionSheet.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 17.06.2022.
//

import UIKit

class UserDataChangeActionSheet {
    
    func create(completion: @escaping (UserInfoChangeViewController.changingType)->()) -> UIAlertController {
        
        let userInfoChangeActionSheet = UIAlertController(title: NSLocalizedString("Select user info to change", comment: ""), message: nil, preferredStyle: .actionSheet)
        
//            Creating actionSheet action
        let changeEmailAction = UIAlertAction(title: NSLocalizedString("Change Email", comment: ""), style: .default) { _ in
            completion(.email)
        }
        
        let chanePassAction = UIAlertAction(title: NSLocalizedString("Change password", comment: ""), style: .default) { _ in
            completion(.password)
        }
        
        let changeAddressAction = UIAlertAction(title: NSLocalizedString("Change address", comment: ""), style: .default) { _ in
            completion(.address)
        }
        
        let changePhoneNumAction = UIAlertAction(title: NSLocalizedString("Change phone number", comment: ""), style: .default) { _ in
            completion(.phoneNum)
        }
        
        let deleteAccountAction = UIAlertAction(title: NSLocalizedString("Delete user account", comment: ""), style: .destructive) { _ in
            completion(.delete)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        userInfoChangeActionSheet.addAction(changeEmailAction)
        userInfoChangeActionSheet.addAction(chanePassAction)
        userInfoChangeActionSheet.addAction(changeAddressAction)
        userInfoChangeActionSheet.addAction(changePhoneNumAction)
        userInfoChangeActionSheet.addAction(deleteAccountAction)
        userInfoChangeActionSheet.addAction(cancel)
        
        return userInfoChangeActionSheet
    }

}
