//
//  DetailViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.03.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let fireAPI = APIManager()
    
    var docID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doc = fireAPI.getDocForID(id: docID)

        image.image =  UIImage(named: "11")
        nameLabel.text = doc?.name
        priceLabel.text = "\(doc?.price ?? 0)"
        descriptionLabel.text = doc?.description
    }
    

}
