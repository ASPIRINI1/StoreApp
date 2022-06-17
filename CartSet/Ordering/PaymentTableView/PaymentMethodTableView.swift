//
//  File.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 18.05.2022.
//

import Foundation
import UIKit

class PaymentMethodTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var paymentMethods = [String]()
    var selectedCell: Optional<PaymentMethods> = nil
    
    enum PaymentMethods: String, CaseIterable {
        case CreditCard = "Credit card"
        case EMoney = "Qiwi/YaMoney"
        case CashOnDelivery = "Сash on delivery"
        case PickUpByYourself = "Pick up by yourself"
    }
    
    func createPaymentTableView() {
        
        for method in PaymentMethods.allCases {
            paymentMethods.append(method.rawValue)
        }
        
        self.delegate = self
        self.dataSource = self
        
        self.layer.cornerRadius = 10
        self.reloadData()
    }
    
//    MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentMethodTableViewCell
        
        cell.paymentNameLabel.text = paymentMethods[indexPath.row]
        
        return cell
    }
    
    //    MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            selectedCell = PaymentMethods.CreditCard
        case 1:
            selectedCell = PaymentMethods.EMoney
        case 2:
            selectedCell = PaymentMethods.CashOnDelivery
        case 3:
            selectedCell = PaymentMethods.PickUpByYourself
        default:
            selectedCell = nil
        }
        
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
}

