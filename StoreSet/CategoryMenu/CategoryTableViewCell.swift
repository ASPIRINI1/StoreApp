//
//  CategoryTableViewCell.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 02.04.2022.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
