//
//  File.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 18.05.2022.
//

import Foundation
import UIKit

class PaymentMethodTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var paymentMethods = [String]()
    
    
    func createPaymentTableView(methods: [String]) {
        
        self.delegate = self
        self.dataSource = self
        
        paymentMethods = methods
        
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
        
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
}

