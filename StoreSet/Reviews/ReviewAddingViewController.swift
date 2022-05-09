//
//  ReviewAddingViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 03.05.2022.
//

import UIKit


class ReviewAddingViewController: UIViewController {
    
    @IBOutlet weak var reviewTextFiled: UITextField!
    @IBOutlet weak var markSegmentedControl: UISegmentedControl!
    
    var docID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    @IBAction func addReviewButtonAction(_ sender: Any) {
        
        if reviewTextFiled.text != ""{
            
            FireAPI.shared.addReview(documentID: docID, text: reviewTextFiled.text!, mark: markSegmentedControl.selectedSegmentIndex + 1)
            
            self.navigationController?.popViewController(animated: true)
            
        } else {
            
            let alert = UIAlertController(title: NSLocalizedString("You must write a text in review text field tp add your review.", comment: ""), message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.reviewTextFiled.becomeFirstResponder()
            }))
            
            present(alert, animated: true)
            
        }  
    }
    
    func setDocID(ID: String) {
        self.docID = ID
    }

}
