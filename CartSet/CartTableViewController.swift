//
//  TableViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 11.04.2022.
//

import UIKit

class CartTableViewController: UITableViewController {
    
    private var cart: [Document] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppSettings.shared.userID != "" {
            APIManager.shared.getUserCart { docs in
                self.cart = docs
                self.tableView.reloadData()
                for product in self.cart {
                    APIManager.shared.getFirstImage(document: product) { image in
                        product.image = image
                        self.tableView.reloadData()
                    }
                }
            }
        }
       
    }

    @IBAction func checkoutButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func eidtButtonAction(_ sender: Any) {
        
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cart.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        
        cell.prodImage.image = cart[indexPath.row].image
        cell.nameLabel.text = cart[indexPath.row].name
        cell.priceAlbel.text = String(cart[indexPath.row].price)
        cell.countLabel.text = "0"
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
