//
//  SettingsTableViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 03.04.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var companySiteButton: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var appThemeSegmentedControl: UISegmentedControl!
    
    
    let appSettings = AppSettings()
    let fireAPI = APIManager()
    var WEBurl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
// MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(indexPath)
        
        switch indexPath {
        case [2, 0]: // about company
            WEBurl = "https://www.google.com"
        case [2, 2]: // about dev
            WEBurl = "https://github.com/ASPIRINI1"
        case [0, 1]:  // pass restore
            break
        case [0, 2]: // exit
            break
        default:
            break
        }
        return indexPath
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
