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
    
    var doc = Document(category: "", subCategory: "", documentID: "", name: "", price: 0, description: "")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        nameLabel.text = doc.name
        priceLabel.text = String(doc.price)
        
        APIManager.shared.getDecscription(doc: doc, completion: { description in
            self.descriptionLabel.text = description
        })
        
        let firstImageView = UIImageView(image: doc.image)
        
        
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
       
    func configureVC(doc: Document) {
        self.doc = doc
    }

    
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.width
        pageControl.currentPage = Int(page)
    }
}
