//
//  OrderingTableViewCell.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 03.05.2022.
//

import UIKit

class GoodsTableViewCell: UITableViewCell {

    @IBOutlet weak var prodImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var pcsLabel: UILabel!
    
    override func awakeFromNib() {
        pcsLabel.text = NSLocalizedString("pcs", comment: "")
    }
    
}

