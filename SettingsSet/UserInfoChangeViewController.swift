//
//  UserInfoChangeViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 10.04.2022.
//

import UIKit

class UserInfoChangeViewController: UIViewController {

    @IBOutlet weak var headerLAbel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstTextBox: UITextField!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondTextBox: UITextField!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdTextBox: UITextField!
    
    enum changingType {
        case email
        case password
        case address
    }
    
    private var viewType = changingType.email
    private let validator = Validator()
    private let appSettings = AppSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        switch viewType {
        case .email:
            print("email")
            if ((firstTextBox.text?.isValidEmail()) != nil) {
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Wrong Email.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.firstTextBox.text?.removeAll()
                }))
            }
            
        case .password:
            print("password")
            if ((secondTextBox.text?.isValidPass()) != nil) {
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Wrong password.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.secondTextBox.text?.removeAll()
                }))
            }
            
            if thirdTextBox.text == secondTextBox.text {
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Passwords do not same.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.thirdTextBox.text?.removeAll()
                }))
            }
            
        case .address:
            print("address")
            if firstTextBox.text != nil {
                appSettings.userAdress = firstTextBox.text ?? ""
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Adress changing fail.", comment: ""), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
            }
            
        }
    }
    
    private func createView() {
        
        switch viewType {
            
        case .email:
            headerLAbel.text = NSLocalizedString("You must confirm the change of email on your new mailbox.", comment: "")
            firstLabel.text = NSLocalizedString("Your new email", comment: "")
            firstTextBox.placeholder = NSLocalizedString("Enter email here", comment: "")
            secondLabel.text = NSLocalizedString("Enter your passord", comment: "")
            secondTextBox.placeholder = NSLocalizedString("password", comment: "")
            
        case .password:
            headerLAbel.text = NSLocalizedString("You must confirm the change of password on your mailbox.", comment: "")
            firstLabel.text = NSLocalizedString("Old password", comment: "")
            firstTextBox.placeholder = NSLocalizedString("Enter old passord here", comment: "")
            secondLabel.text = NSLocalizedString("New password", comment: "")
            secondTextBox.placeholder = NSLocalizedString("Enter new passord here", comment: "")
            thirdLabel.isHidden = false
            thirdTextBox.isHidden = false
            thirdLabel.text = NSLocalizedString("Write new password again", comment: "")
            
        case .address:
            headerLAbel.text = NSLocalizedString("You must confirm the change of address on your mailbox.", comment: "")
            firstLabel.text = NSLocalizedString("Adress", comment: "")
            firstTextBox.placeholder = NSLocalizedString("Enter old passord here", comment: "")
            secondLabel.isHidden = true
            secondTextBox.isHidden = true
        }
    }
    
    func setViewType(viewType: changingType) {
        self.viewType = viewType
    }
}
