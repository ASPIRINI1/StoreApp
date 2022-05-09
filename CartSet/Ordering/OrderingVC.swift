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
    @IBOutlet weak var goodsListTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var products: [Document] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        
    }
    
    private func configureVC() {
//        fullnameLabel.text = AppSettings.shared.
        addressLabel.text = AppSettings.shared.userAdress
        goodsListTableView.layer.cornerRadius = 10
        
        var totalPrice = 0
        
        for product in products {
            totalPrice += product.price
        }
        
        totalPriceLabel.text = String(totalPrice)
    }
    
    func setProducts(products: [Document]) {
        self.products = products
    }
    
    @IBAction func byButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func changeUserDataButtonAction(_ sender: Any) {
    }

}

// MARK: - UITableViewDelegate

extension OrderingVC: UITableViewDelegate, UITableViewDataSource {
    
//  goodsCell spasing
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(1)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return CGFloat(1)
    }
    
    
    
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderingCell", for: indexPath) as! OrderingTableViewCell
        
        cell.nameLabel.text = products[indexPath.section].name
        cell.priceLabel.text = String(products[indexPath.section].price) + NSLocalizedString("Rub", comment: "")
        cell.prodImage.image = products[indexPath.section].image
        
//        cell.layer.cornerRadius = 10
        
        return cell
    }
}



