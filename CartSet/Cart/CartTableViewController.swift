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
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if AppSettings.shared.userID != "" {
            FireAPI.shared.getUserCart { docs in
                self.cart = docs
                self.tableView.reloadData()
                
                for product in self.cart {
                    
                    FireAPI.shared.getFirstImage(document: product) { image in
                        product.image = image
                        self.tableView.reloadData()
                    }
                    
                    if product.documentID == self.cart.last?.documentID {
                        self.getTotalSum()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

//    MARK: - Actions
    
    @IBAction func eidtButtonAction(_ sender: Any) {
        
    }
    
//    MARK: - Additional funcs
    
    func getTotalSum(){
        
        var sum = 0
        
        for product in cart {
            sum += product.price
        }
        totalPriceLabel.title = String(sum) + " " + NSLocalizedString("Rub", comment: "")
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetailViewController {
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.setDocument(docoment: cart[selectedIndex])
            return
        }
        
        if segue.destination is OrderingVC {
            
            if cart.isEmpty {
                
                let alert = UIAlertController(title: NSLocalizedString("Add some goods in cart first.", comment: ""), message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                present(alert, animated: true)
            }
            
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
            FireAPI.shared.removeFromCart(document: cart[indexPath.row])
            cart.remove(at: indexPath.row)
            getTotalSum()
            tableView.reloadData()
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
