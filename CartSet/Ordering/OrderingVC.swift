//
//  OrderingVC.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 14.04.2022.
//

import UIKit

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
        
        configureVC()
       
//         creating payment method tableView
        paymentMethodTableView.createPaymentTableView(methods: [NSLocalizedString("Credit card", comment: ""),
                                                                NSLocalizedString("Qiwi/YaMoney", comment: ""),
                                                                NSLocalizedString("Сash on delivery", comment: ""),
                                                                NSLocalizedString("Pick up by yourself", comment: "")])
        
//         creating goods list tableView
        goodsListTableView.createGoodsTableView(goods: products)
    }
    
    //    MARK: - Configuring ViewController
    
    private func configureVC() {

        fullnameLabel.text = AppSettings.shared.user?.fullName
        addressLabel.text = AppSettings.shared.user?.address
        emailLabel.text = AppSettings.shared.user?.email
        
        var totalPrice = 0
        
        for product in products {
            totalPrice += product.product.price * product.count
        }
        
        totalPriceLabel.text = String(totalPrice) + " " + NSLocalizedString("Rub", comment: "")
    }
    
    func setProducts(products: [(Document,Int)]) {
        self.products = products
    }
    
//    MARK: - Actions
    
    @IBAction func byButtonAction(_ sender: Any) {
        
        
        let alert = UIAlertController(title: NSLocalizedString("Do you want to pay with apple pay?", comment: ""), message: nil, preferredStyle: .alert)
        
        let yesAletrAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { _ in
            
        }
        
        let noAlertAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default) { _ in
            
            let paymentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
            
            
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
        
        alert.addAction(yesAletrAction)
        alert.addAction(noAlertAction)
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func changeUserDataButtonAction(_ sender: Any) {
        
        
    }

}




