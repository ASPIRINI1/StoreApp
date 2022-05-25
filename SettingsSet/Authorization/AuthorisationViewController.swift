//
//  AuthorisationViewController.swift
//  NotesApp
//
//  Created by Станислав Зверьков on 25.02.2022.
//

import UIKit

class AuthorisationViewController: UIViewController {
    

    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var substrateView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        emailTextField.delegate = self
        
        substrateView.layer.cornerRadius = 20
        
        if traitCollection.userInterfaceStyle == .dark {
            substrateView.backgroundColor = .systemGray6
            emailTextField.backgroundColor =  .darkGray
            passwordTextField.backgroundColor = .darkGray
        }
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
    }
    
    
    //MARK: Actions
    
    
    @IBAction func signInButtAction(_ sender: Any) {
        
        if Validator.shared.userDataIsCurrect(email: emailTextField.text, pass: passwordTextField.text) {
            
            FireAPI.shared.signIn(email: emailTextField.text!, password: passwordTextField.text!) { Success in
                if !Success {
                    let alert = UIAlertController(title: NSLocalizedString("SignIn Error", comment: ""), message: NSLocalizedString("Network unable or email do not exist.", comment: ""), preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            validationLabel.isHidden = false
            validationLabel.text = NSLocalizedString("Error. Check your email or password.", comment: "")
        }
    }
    
    //MARK: Additional funcs
    
    @objc func dismissKeyboard(Sender: UITapGestureRecognizer) {
       view.endEditing(true)
    }
    
}

//MARK: - UITextFieldDelegate

extension AuthorisationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if emailTextField.isFirstResponder{
            passwordTextField.becomeFirstResponder()
        }
        if passwordTextField.isFirstResponder {
            signInButton.sendActions(for: .touchUpInside)
        }
        return true
    }
}
