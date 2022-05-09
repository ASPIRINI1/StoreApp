//
//  ReviewTableViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 03.05.2022.
//

import UIKit

class ReviewsTableViewController: UITableViewController {
    
    var docID = ""
    var reviews : [Review] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        FireAPI.shared.getReviews(documentID: docID) { reviews in
            self.reviews = reviews
            
            if reviews.isEmpty {
                
                let noReviewsLabel = UILabel(frame: self.view.bounds)
                noReviewsLabel.tintColor = .systemGray4
                noReviewsLabel.textAlignment = .center
                noReviewsLabel.text = NSLocalizedString("No reviews yet.", comment: "")
                
                self.view.addSubview(noReviewsLabel)
            }
//            self.tableView.reloadData()
        }

    }

    
    func setDocID(ID: String) {
        self.docID = ID
    }
    
    func addReview(text: String, mark: Int) {
        print("AddREview")
        reviews.append(Review(text: text, mark: mark))
        reviews[reviews.count-1].setAuthor(ID: AppSettings.shared.userID, name: AppSettings.shared.userFullName)
        print(reviews.count)
//        tableView.reloadData()
    }
        
    
//    MARK: Table viw Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let cell = tableView.cellForRow(at: indexPath) as! ReviewsTableViewCell
        if cell.authorrNameLabel.text == AppSettings.shared.userFullName {
            
        }
        return .none
    }
    
    // MARK: - Table view Data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return reviews.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewsTableViewCell

        cell.authorrNameLabel.text = reviews[indexPath.section].authorName
        cell.reviewTextLabel.text = reviews[indexPath.section].text
        cell.rateLabel.text = String(reviews[indexPath.section].mark)
        
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
