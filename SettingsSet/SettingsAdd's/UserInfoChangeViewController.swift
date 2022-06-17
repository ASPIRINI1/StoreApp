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
        case phoneNum
        case delete
    }
    
//    MARK: - Properties
    
    var viewType = changingType.email
    
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
            
            if firstTextField.text != nil && firstTextField.text!.isValidEmail() {
                FireAPI.shared.changeUser(email: firstTextField.text!, completion: { success in
                
                    if success {
                        self.navigationController?.popViewController(animated: true)

                    } else {
                        self.showUpdatingErrorAlert()
                    }
                })
                
                
            } else {
                
                let alert = UIAlertController(title: NSLocalizedString("Wrong Email.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.firstTextField.text?.removeAll()
                }))
                present(alert, animated: true)
            }
            
        case .password:
     
            if secondTextField.text == nil || !secondTextField.text!.isValidPass() {
                
                let alert = UIAlertController(title: NSLocalizedString("Wrong password.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.secondTextField.text?.removeAll()
                }))
                present(alert, animated: true)
            }
            
            // check password identity
            if thirdTextField.text == secondTextField.text {
                
                FireAPI.shared.changeUser(password: secondTextField.text!, completion: { success in
                    
                    if success {
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        self.showUpdatingErrorAlert()
                    }
                })
                navigationController?.popViewController(animated: true)
                
            } else {
                
                let alert = UIAlertController(title: NSLocalizedString("Passwords do not same.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.thirdTextField.text?.removeAll()
                }))
                present(alert, animated: true)
            }
            
        case .address:
            
            if firstTextField.text != nil {
                
                FireAPI.shared.changeUser(address: firstTextField.text!, completion: { success in
                    
                    if success {
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        self.showUpdatingErrorAlert()
                    }
                })
                
                navigationController?.popViewController(animated: true)
                
            } else {
                
                let alert = UIAlertController(title: NSLocalizedString("Wrong acddress.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.firstTextField.text?.removeAll()
                }))
                present(alert, animated: true)
            }
            
        case .phoneNum:
            
            if firstTextField.text != nil && firstTextField.text!.isValidProneNum() {
                FireAPI.shared.changeUser(phoneNum: Int(firstTextField.text!)!, completion: { success in
                    
                    if success {
                        self.navigationController?.popViewController(animated: true)
                        
                    } else {
                        
                        self.showUpdatingErrorAlert()
                    }
                })
                
                
            } else {
                
                let alert = UIAlertController(title: NSLocalizedString("Wrong phone number.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.firstTextField.text?.removeAll()
                }))
                present(alert, animated: true)
            }
        case .delete:
            break
        }
    }
    
//    MARK: - Creating view
    
    private func createView() {
        
        switch viewType {
            
        case .email:
            
            headerLAbel.text = NSLocalizedString("You must confirm the change of email on your new mailbox.", comment: "")
            
            firstLabel.text = NSLocalizedString("Your new email", comment: "")
            firstTextField.placeholder = NSLocalizedString("Enter email here", comment: "")
            
            secondLabel.text = NSLocalizedString("Enter your passord", comment: "")
            secondTextField.placeholder = NSLocalizedString("password", comment: "")
            secondTextField.isSecureTextEntry = true
            
        case .password:
            
            headerLAbel.text = NSLocalizedString("You must confirm the change of password on your mailbox.", comment: "")
            
            firstLabel.text = NSLocalizedString("Old password", comment: "")
            firstTextField.placeholder = NSLocalizedString("Enter old passord here", comment: "")
            firstTextField.isSecureTextEntry = true
            
            secondLabel.text = NSLocalizedString("New password", comment: "")
            secondTextField.placeholder = NSLocalizedString("Enter new passord here", comment: "")
            secondTextField.isSecureTextEntry = true
            
            thirdLabel.isHidden = false
            thirdLabel.text = NSLocalizedString("Write new password again", comment: "")
            thirdTextField.isHidden = false
            thirdTextField.isSecureTextEntry = true
            
            
            
        case .address:
            
            headerLAbel.text = NSLocalizedString("Write your new address.", comment: "")
            
            firstLabel.text = NSLocalizedString("Adress", comment: "")
            firstTextField.placeholder = NSLocalizedString("Enter new address here", comment: "")
            
            secondLabel.isHidden = true
            secondTextField.isHidden = true
            
        case .phoneNum:
            
            headerLAbel.text = NSLocalizedString("Write your new phone num.", comment: "")
            firstLabel.text = NSLocalizedString("New phone num", comment: "")
            
            secondLabel.isHidden = true
            secondTextField.isHidden = true
        case .delete:
            break
        }
        
    }
    
//    MARK: - Additional funcs
    
    
    func showUpdatingErrorAlert() {
                    
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                      message: NSLocalizedString("Error update data. Check your internet connection and try again.", comment: ""),
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    @objc func dismissKeyboard(selector: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
}

