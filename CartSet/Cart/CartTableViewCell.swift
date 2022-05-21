//
//  CartTableViewCell.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 11.04.2022.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prodImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceAlbel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        countLabel.text = String(Int(sender.value))
    } 
}
