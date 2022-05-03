//
//  DetailViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.03.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var doc = Document(category: "", subCategory: "", documentID: "", name: "", price: 0, description: "")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureVC()
        
    }
       
    @IBAction func addToCartButtonAction(_ sender: Any) {
        
        if AppSettings.shared.userID != "" {
            APIManager.shared.addToCart(document: doc)
            
        } else {
            
            let alert = UIAlertController(title: NSLocalizedString("You must register to add items to your shopping cart.", comment: ""), message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { alertAction in
                
                self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthorisationViewController"), animated: true)
            }))
            
            present(alert, animated: true)
        }
        
    }
    
    @IBAction func byNowButtonAction(_ sender: Any) {
        
    }
    @IBAction func reviewsButtonAction(_ sender: Any) {
        
    }
    
    private func configureVC() {
        
        nameLabel.text = doc.name
        priceLabel.text = String(doc.price)
        
        APIManager.shared.getDecscription(doc: doc, completion: { description in
            self.descriptionLabel.text = description
        })
        
        let firstImageView = UIImageView(image: doc.image)
        
        firstImageView.frame = CGRect(x: self.imageScrollView.contentSize.width, y: 0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
        firstImageView.backgroundColor = .white
        firstImageView.contentMode = .scaleAspectFit
        
        imageScrollView.contentSize.width += imageScrollView.frame.width
        imageScrollView.addSubview(firstImageView)
        
                    APIManager.shared.getProductImages(doc: doc) { images in
                        
                    for image in images! {
                        
                        let imageView = UIImageView(image: image)
                        
                        imageView.frame = CGRect(x: self.imageScrollView.contentSize.width, y: 0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
                        imageView.backgroundColor = .white
                        imageView.contentMode = .scaleAspectFit
                        
                        self.imageScrollView.contentSize.width += imageView.frame.width
                        self.imageScrollView.addSubview(imageView)
                    }
                }
    }
    
    func setDocument(docoment: Document) {
        doc = docoment
    }

    
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.width
        pageControl.currentPage = Int(page)
    }
}
