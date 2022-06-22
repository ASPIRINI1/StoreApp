//
//  OrderingVC.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 14.04.2022.
//

import UIKit
import PassKit

class OrderingVC: UIViewController {

    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var goodsListTableView: GoodsTableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var paymentMethodTableView: PaymentMethodTableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    private var products = [(product: Document ,count: Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configuring OrderingVC
        configureVC()
       
//         creating payment method tableView
        paymentMethodTableView.createPaymentTableView()
        
//         creating goods list tableView
        goodsListTableView.createGoodsTableView(goods: products)
    }
    
    //    MARK: - Configuring ViewController
    
    private func configureVC() {

        fullnameLabel.text = AppSettings.shared.user?.fullName
        addressLabel.text = AppSettings.shared.user?.address
        emailLabel.text = AppSettings.shared.user?.email
        
        totalPriceLabel.text = String(getTotalPrice()) + " " + NSLocalizedString("Rub", comment: "")
    }
    
    func setProducts(products: [(Document,Int)]) {
        self.products = products
    }
    
//    MARK: - Actions
    
    @IBAction func byButtonAction(_ sender: Any) {
        
        guard let selectedPaymentMethod = paymentMethodTableView.selectedCell else {
            
//            "Please select delivering method."
            let alert = UIAlertController(title: NSLocalizedString("Please select payment method.", comment: ""), message: nil, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(OKAction)
            present(alert, animated: true)
            
            return
        }
        
        let paymentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        
        switch selectedPaymentMethod {
        case .CreditCard:
            let alert = UIAlertController(title: NSLocalizedString("Do you want to pay with apple pay?", comment: ""), message: nil, preferredStyle: .alert)
            
            let yesAletrAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { _ in
                self.applePay()
                FireAPI.shared.addToSales(products: self.products)
            }
            
            let noAlertAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default) { _ in
                
                paymentVC.products = self.products
                paymentVC.selectedMethod = selectedPaymentMethod
                self.navigationController?.pushViewController(paymentVC, animated: true)
            }
            
            alert.addAction(yesAletrAction)
            alert.addAction(noAlertAction)
            
            self.present(alert, animated: true)
            
        case .EMoney:
            paymentVC.selectedMethod = selectedPaymentMethod
            paymentVC.products = products
            self.navigationController?.pushViewController(paymentVC, animated: true)
            
        case .CashOnDelivery:
            FireAPI.shared.addToSales(products: self.products)
            
        case .PickUpByYourself:
            FireAPI.shared.addToSales(products: self.products)
        }
        
   
        
    }
    
    @IBAction func changeUserDataButtonAction(_ sender: Any) {
        
        let userInfoChangeActionSheet = UserDataChangeActionSheet().create { changingType in
            
            let userInfoChangeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoChangeViewController
            
            if changingType == .delete { return }
            
            userInfoChangeVC.viewType = changingType
            self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
        }
        present(userInfoChangeActionSheet, animated: true)
    }

    
//    MARK: - Additional funcs
    
    func getTotalPrice() -> Int {
        
        var totalPrice = 0
        
        for product in products {
            totalPrice += product.product.price * product.count
        }
        return totalPrice
    }
    
    func applePay() {
        let paymentRequest: PKPaymentRequest = {
            let request = PKPaymentRequest()
            request.supportedNetworks = [.visa,.masterCard]
            request.supportedCountries = ["RU", "UA"]
            request.merchantIdentifier = "merchant.com.pushpendra.pay"
            request.countryCode = "RU"
            request.currencyCode = "RUB"
            request.merchantCapabilities = .capability3DS
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "StoreApp", amount: NSDecimalNumber(value: getTotalPrice()))]
            return request
        }()
        let paymentController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if paymentController != nil {
            paymentController!.delegate = self
            present(paymentController!, animated: true)
        }
    }
}

extension OrderingVC: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
}




