//
//  RegistrationViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 04.04.2022.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullNameTextFiedl: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var substrateView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.validationLabel.isHidden = true
        
        substrateView.layer.cornerRadius = 20
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
        registerNotifications()

    }
    
//MARK: deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
//    MARK: - actions
    
    @IBAction func registrationButton(_ sender: Any) { // add user data!!
        
        validationLabel.isHidden = false
        
        if !emailTextField.text!.isValidEmail() {
            validationLabel.text = NSLocalizedString("This email is uncurrect.", comment: "")
            return
        }
        
        if !passwordTextField.text!.isValidPass() {
            validationLabel.text = NSLocalizedString("Uncurrect password.", comment: "")
            return
        }
        
        if fullNameTextFiedl.text == nil || !fullNameTextFiedl.text!.isValidFullName() {
            validationLabel.text = NSLocalizedString("Check your fullname.", comment: "")
            return
        }
        
        if addressTextField.text == nil {
            validationLabel.text = NSLocalizedString("Check your address.", comment: "")
            return
        }

        if phoneNumTextField.text == nil || !phoneNumTextField.text!.isValidProneNum() {
            validationLabel.text = NSLocalizedString("Check you phone num.", comment: "")
            return
        }
            
            validationLabel.isHidden = true
        
            FireAPI.shared.registration(email: emailTextField.text!, password: passwordTextField.text!, userName: fullNameTextFiedl.text!, address: addressTextField.text!, phoneNum: Int(phoneNumTextField.text!)!) { regSuccess in

                if !regSuccess {
                    let alert = UIAlertController(title: NSLocalizedString("Registration Error", comment: ""), message: NSLocalizedString("Network unable or email already exist.", comment: ""), preferredStyle: .alert)

                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                self.navigationController?.popToRootViewController(animated: true)
            }

    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
//    MARK: - notifications
    
    func registerNotifications() {
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [self] notif in
            if self.addressTextField.isFirstResponder {
                self.view.frame.origin.y -= self.addressTextField.frame.height * 2 //?????????
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { notif in
            self.view.frame.origin.y = 0
            
        }
    }
    
//    MARK: - additional funcs
 
    @objc func dismissKeyboard(Sender: UITapGestureRecognizer){
       view.endEditing(true)
    }
    
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if addressTextField.isFirstResponder {
            registrationButton.sendActions(for: .touchUpInside)
        }
        if fullNameTextFiedl.isFirstResponder {
            addressTextField.becomeFirstResponder()
        }
        if passwordTextField.isFirstResponder {
            fullNameTextFiedl.becomeFirstResponder()
        }
        if emailTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        }



        return true
    }
    
    
}
