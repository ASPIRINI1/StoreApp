//
//  TableViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 11.04.2022.
//

import UIKit

class CartTableViewController: UITableViewController {
    
    @IBOutlet weak var totalPriceLabel: UIBarButtonItem!
    
    private var cart: [Document] = []
    private var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppSettings.shared.userID != "" {
            APIManager.shared.getUserCart { docs in
                self.cart = docs
                self.tableView.reloadData()
                var totalPrice = 0
                
                for product in self.cart {
                    APIManager.shared.getFirstImage(document: product) { image in
                        product.image = image
                        totalPrice += product.price
                        self.totalPriceLabel.title! = String(totalPrice) + NSLocalizedString("Rub", comment: "")
                        self.tableView.reloadData()
                    }
                }
            }
        }
       
    }

//    MARK: - Actions
    
    @IBAction func eidtButtonAction(_ sender: Any) {
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetailViewController {
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.setDocument(docoment: cart[selectedIndex])
            return
        }
        
        if segue.destination is OrderingVC {
            
            if AppSettings.shared.userID != "" {
                
                let orderingVC = segue.destination as! OrderingVC
                orderingVC.setProducts(products: cart)
                
            } else {
                
                let alert = UIAlertController(title: NSLocalizedString("You must register to make purchases.", comment: ""), message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { alertAction in
                    
                    self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthorisationViewController"), animated: true)
                }))
                
                present(alert, animated: true)
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            APIManager.shared.removeFromCart(document: cart[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

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
    
//    MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    

}