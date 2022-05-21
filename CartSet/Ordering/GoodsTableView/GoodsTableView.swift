//
//  GoodsTableView.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 18.05.2022.
//

import Foundation
import UIKit

class GoodsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var products = [(product: Document ,count: Int)]()
    
    func createGoodsTableView(goods: [(product: Document ,count: Int)]) {
        
        self.dataSource = self
        self.delegate = self
        
        products = goods
        
        self.layer.cornerRadius = 10
        self.reloadData()
    }
      
//        MARK: - UITableViewDataSource
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as! GoodsTableViewCell
        
        cell.nameLabel.text = products[indexPath.section].product.name
        cell.priceLabel.text = String(products[indexPath.section].product.price) + NSLocalizedString("Rub", comment: "")
        cell.prodImage.image = products[indexPath.section].product.image
        cell.countLabel.text = String(products[indexPath.row].count)
        
        return cell
    }
    
    //        MARK: - UITableViewDelegate
        
    //      goodsCell spasing
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(1)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(1)
    }
            
}
