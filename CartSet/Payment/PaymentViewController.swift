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
    
    var selectedMethod = PaymentMethodTableView.PaymentMethods.CreditCard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    @IBAction func CouniniueButtonAction(_ sender: Any) {
        
        guard let text = textField.text else {
            return
        }
          
        if text.isValidVisa() {
            cardTypeLabel.isHidden = false
            cardTypeLabel.text = "Visa"
        }
        
        if text.isValidMasterCard() {
            cardTypeLabel.isHidden = false
            cardTypeLabel.text = "MasterCard"
        }
        
        if text.isValidVisa() || text.isValidMasterCard() {
            
            let alert = UIAlertController(title: NSLocalizedString("Your order your order is being processed.", comment: ""), message: nil, preferredStyle: .alert)
            
            let OKAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alert.addAction(OKAlertAction)
            
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Rewrite your card num.", comment: ""), message: nil, preferredStyle: .alert)
            
            let OKAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alert.addAction(OKAlertAction)
            
            self.present(alert, animated: true)
        }

    }
    
    private func configureVC() {
        
        switch selectedMethod {
        case .CreditCard:
            label.text = NSLocalizedString("Please write your credit card num.", comment: "")
        case .EMoney:
            label.text = NSLocalizedString("Please write your Emoney card num.", comment: "")
        case .CashOnDelivery:
            break
        case .PickUpByYourself:
            break
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
