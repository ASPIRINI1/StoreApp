//
//  DetailViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 23.03.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageScrollView: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let fireAPI = APIManager()
    
    var docID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doc = fireAPI.getDocForID(id: docID)
        
        let images: [UIImage] = [UIImage(named: "111")!, UIImage(named: "222")!,UIImage(named: "33")!,UIImage(named: "44")!,UIImage(named: "55")!]

        for image in images {
            
            let imageView = UIImageView(image: image)
            imageView.backgroundColor = self.view.backgroundColor
            imageView.frame = CGRect(x: scrollView.contentSize.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit
            
            scrollView.contentSize.width += imageView.frame.width
            scrollView.addSubview(imageView)
            imageScrollView.backgroundColor = self.view.backgroundColor
        }
        
//        nameLabel.text = doc?.name
//        priceLabel.text = "\(doc?.price ?? 0)"
//        descriptionLabel.text = doc?.description
        nameLabel.text = "namelabel"
        priceLabel.text = "pricelabel"
        descriptionLabel.text = "text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample text sample"
    }
    

}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.width
        pageControl.currentPage = Int(page)
    }
}
