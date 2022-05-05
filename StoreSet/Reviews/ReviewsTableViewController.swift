//
//  ReviewTableViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 03.05.2022.
//

import UIKit

class ReviewsTableViewController: UITableViewController {
    
    var docID = ""
    var reviews : [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        APIManager.shared.getReviews(documentID: docID) { reviews in
            self.reviews = reviews
            
            if reviews.isEmpty {
                
                let noReviewsLabel = UILabel(frame: self.view.bounds)
                noReviewsLabel.tintColor = .systemGray4
                noReviewsLabel.textAlignment = .center
                noReviewsLabel.text = NSLocalizedString("No reviews yet.", comment: "")
                
                self.view.addSubview(noReviewsLabel)
            }
            self.tableView.reloadData()
        }
    }

    
    func setDocID(ID: String) {
        self.docID = ID
    }
    
    func addReview(author: String, text: String, mark: Int) {
        reviews.append(Review(authorName: author, text: text, mark: mark))
        tableView.reloadData()
    }
        
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewsTableViewCell

        cell.authorrNameLabel.text = reviews[indexPath.row].authorName
        cell.reviewTextLabel.text = reviews[indexPath.row].text
        
        return cell
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ReviewAddingViewController {
            
            if AppSettings.shared.signedIn {
    
                let reviewAddVC = segue.destination as! ReviewAddingViewController
                reviewAddVC.setDocID(ID: docID)
    
            } else {
    
                let alert = UIAlertController(title: NSLocalizedString("You must register first.", comment: ""), message: nil, preferredStyle: .alert)
    
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
    
                    let authorizationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthorisationViewController") as! AuthorisationViewController
    
                    self.navigationController?.pushViewController(authorizationVC, animated: true)
                }))
    
                present(alert, animated: true)
            }
            
        }
        
    }
    

}
