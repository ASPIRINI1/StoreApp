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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
