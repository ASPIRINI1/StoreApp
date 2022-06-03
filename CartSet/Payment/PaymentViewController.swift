//
//  PaymentViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 02.06.2022.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cardTypeLabel: UILabel!
    
    enum PaymentMethod {
    case Emoney
    case CreditCard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func CouniniueButtonAction(_ sender: Any) {
        
        if let text = textField.text {
            
            if text.isValidVisa() {
                cardTypeLabel.isHidden = false
                cardTypeLabel.text = "Visa"
            }
            
            if text.isValidMasterCard() {
                cardTypeLabel.isHidden = false
                cardTypeLabel.text = "MasterCard"
            }
        }
    }
    
    func coufigureVC(paymentMethod: PaymentMethod) {
        
        switch paymentMethod {
        case .Emoney:
            label.text = NSLocalizedString("Please write your Emoney card num.", comment: "")
        case .CreditCard:
            label.text = NSLocalizedString("Please write your credit card num.", comment: "")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
