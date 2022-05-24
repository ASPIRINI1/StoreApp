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
    @IBOutlet weak var paymentMethodTableView: PaymentTableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    private var products = [(product: Document ,count: Int)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
       
        // creating payment method tableView
        paymentMethodTableView.createPaymentTableView(methods: [NSLocalizedString("Credit card", comment: ""),
                                                                NSLocalizedString("Qiwi/YaMoney", comment: ""),
                                                                NSLocalizedString("Сash on delivery", comment: ""),
                                                                NSLocalizedString("Pick up by yourself", comment: "")])
        // creating goods list tableView
        goodsListTableView.createGoodsTableView(goods: products)
    }
    
    //    MARK: - Configuring ViewController
    
    private func configureVC() {

        fullnameLabel.text = AppSettings.shared.user?.fullName
        addressLabel.text = AppSettings.shared.user?.address
        emailLabel.text = AppSettings.shared.user?.email
        
        var totalPrice = 0
        
        for product in products {
            totalPrice += product.product.price
        }
        
        totalPriceLabel.text = String(totalPrice) + " " + NSLocalizedString("Rub", comment: "")
    }
    
    func setProducts(products: [(Document,Int)]) {
        self.products = products
    }
    
//    MARK: - Actions
    
    @IBAction func byButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func changeUserDataButtonAction(_ sender: Any) {
        
        
    }

}




