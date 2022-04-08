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
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var registrationButton: UIButton!
    
    let validator = Validator()
    let fireAPI = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.validationLabel.isHidden = true
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)

    }
    
//    MARK: - actions
    
    @IBAction func registrationButton(_ sender: Any) { // add user data!!
        
        if validator.userDataIsCurrect(email: emailTextField.text, pass: emailTextField.text) {

            fireAPI.registration(email: emailTextField.text!, password: passwordTextField.text!) { regSuccess in

                if !regSuccess {
                    let alert = UIAlertController(title: NSLocalizedString("Registration Error", comment: ""), message: NSLocalizedString("Network unable or email already exist.", comment: ""), preferredStyle: .alert)

                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            self.validationLabel.isHidden = false
            self.validationLabel.text = NSLocalizedString("Check your email and password.", comment: "")
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
//    MARK: - additional funcs
 
    @objc func dismissKeyboard(Sender: UITapGestureRecognizer){
       view.endEditing(true)
    }
    
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("dsafds")

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
