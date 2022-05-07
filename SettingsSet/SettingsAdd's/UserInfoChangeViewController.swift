//
//  UserInfoChangeViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 10.04.2022.
//

import UIKit

class UserInfoChangeViewController: UIViewController {

//    MARK: Outlets
    
    @IBOutlet weak var headerLAbel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdTextField: UITextField!
    
    enum changingType {
        case email
        case password
        case address
    }
    
//    MARK: - Properties
    
    private var viewType = changingType.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
    }
    
//    MARK: - Actions
    
    @IBAction func buttonAction(_ sender: Any) {
        switch viewType {
        case .email:
            print("email")
            if ((firstTextField.text?.isValidEmail()) != nil) {
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Wrong Email.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.firstTextField.text?.removeAll()
                }))
            }
            
        case .password:
            print("password")
            if ((secondTextField.text?.isValidPass()) != nil) {
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Wrong password.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.secondTextField.text?.removeAll()
                }))
            }
            
            if thirdTextField.text == secondTextField.text {
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Passwords do not same.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.thirdTextField.text?.removeAll()
                }))
            }
            
        case .address:
            print("address")
            if firstTextField.text != nil {
                AppSettings.shared.userAdress = firstTextField.text ?? ""
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Adress changing fail.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
            }
            
        }
    }
    
//    MARK: - Additional funcs
    
    private func createView() {
        
        switch viewType {
            
        case .email:
            headerLAbel.text = NSLocalizedString("You must confirm the change of email on your new mailbox.", comment: "")
            firstLabel.text = NSLocalizedString("Your new email", comment: "")
            firstTextField.placeholder = NSLocalizedString("Enter email here", comment: "")
            secondLabel.text = NSLocalizedString("Enter your passord", comment: "")
            secondTextField.placeholder = NSLocalizedString("password", comment: "")
            
        case .password:
            headerLAbel.text = NSLocalizedString("You must confirm the change of password on your mailbox.", comment: "")
            firstLabel.text = NSLocalizedString("Old password", comment: "")
            firstTextField.placeholder = NSLocalizedString("Enter old passord here", comment: "")
            secondLabel.text = NSLocalizedString("New password", comment: "")
            secondTextField.placeholder = NSLocalizedString("Enter new passord here", comment: "")
            thirdLabel.isHidden = false
            thirdTextField.isHidden = false
            thirdLabel.text = NSLocalizedString("Write new password again", comment: "")
            
        case .address:
            headerLAbel.text = NSLocalizedString("You must confirm the change of address on your mailbox.", comment: "")
            firstLabel.text = NSLocalizedString("Adress", comment: "")
            firstTextField.placeholder = NSLocalizedString("Enter old passord here", comment: "")
            secondLabel.isHidden = true
            secondTextField.isHidden = true
        }
    }
    
    func setViewType(viewType: changingType) {
        self.viewType = viewType
    }
    
    @objc func dismissKeyboard(selector: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
}

extension UserInfoChangeViewController: UITextFieldDelegate {
    
}
