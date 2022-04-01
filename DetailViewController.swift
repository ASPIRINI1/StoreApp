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
    
    let fireAPI = APIManager()
    
    var docID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        image.image =  UIImage(named: "11")
        nameLabel.text = docID
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
