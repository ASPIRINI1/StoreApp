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
    
//    var docID = ""
    var doc = Document(category: "", subCategory: "", documentID: "", name: "", price: 0, description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//                var images: [UIImage] = []
//
//                for image in images {
//
//                    let imageView = UIImageView(image: image)
//                    imageView.backgroundColor = self.view.backgroundColor
//                    imageView.frame = CGRect(x: imageScrollView.contentSize.width, y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height)
//                    imageView.contentMode = .scaleAspectFit
//
//                    imageScrollView.contentSize.width += imageView.frame.width
//                    imageScrollView.addSubview(imageView)
//                    imageScrollView.backgroundColor = self.view.backgroundColor
//                }
        
        
                    nameLabel.text = doc.name
                    priceLabel.text = String(doc.price)
                    descriptionLabel.text = doc.description
        
        
                APIManager.shared.getProductImages(category: doc.category, subCategory: doc.subCategory, docID: doc.documentID) { images in
                    print(images?.count)
                    print(self.doc.category)
                    for image in images! {
                        print("iuiouiouiouio")
                        let imageView = UIImageView(image: image)
                        imageView.backgroundColor = .white
                        imageView.frame = CGRect(x: self.imageScrollView.contentSize.width, y: 0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
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
