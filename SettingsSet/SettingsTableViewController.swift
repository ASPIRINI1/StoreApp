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
    
    //    MARK:  App theme
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        switch appThemeSegmentedControl.selectedSegmentIndex{
        case 0: tabBarController?.overrideUserInterfaceStyle = .unspecified
            appSettings.appTheme = 0
        case 1: tabBarController?.overrideUserInterfaceStyle = .dark
            appSettings.appTheme = 1
        case 2: tabBarController?.overrideUserInterfaceStyle = .light
            appSettings.appTheme = 2
        default:
            tabBarController?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    //    MARK:  SingIn & SignOut
    
    
    @IBAction func signInButtonAction(_ sender: Any) {
        
        if appSettings.signedIn {
            let alert = UIAlertController(title: NSLocalizedString("Are You shure?", comment: ""), message: NSLocalizedString("Do You want to logOut?", comment: ""), preferredStyle: .alert)
            
            let alertYesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { UIAlertAction in
                self.fireAPI.signOut()
                self.signInButton.setTitle(NSLocalizedString("Sign in", comment: ""), for: .normal)
                self.accountLabel.text = NSLocalizedString("authorization", comment: "")
            }
            
            let alertCancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
            
            alert.addAction(alertCancelAction)
            alert.addAction(alertYesAction)
            
            present(alert, animated: true, completion: nil)

        } else {
            let AuthorisationVС = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AuthorisationViewController") as? AuthorisationViewController
            
            self.navigationController?.pushViewController(AuthorisationVС!, animated: true)
        }
    }
    
//    MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is WEBViewController {
            let webView = segue.destination as! WEBViewController
            webView.openWEBForURl(url: WEBurl)
        }
    }

    
// MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userInfoChangeVC = storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoChangeViewController
        
//        Creating Alert
        if indexPath == [0, 1] {
            let userInfoChangeActionSheet = UIAlertController(title: NSLocalizedString("Select user info to change", comment: ""), message: nil, preferredStyle: .actionSheet)
            
//            Creating aletr action
            let changeEmailAction = UIAlertAction(title: NSLocalizedString("Change Email", comment: ""), style: .default) { _ in
                userInfoChangeVC.setViewType(viewType: .email)
                self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
            }
            let chanePassAction = UIAlertAction(title: NSLocalizedString("Change password", comment: ""), style: .default) { _ in
                userInfoChangeVC.setViewType(viewType: .password)
                self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
            }
            let changeAddressAction = UIAlertAction(title: NSLocalizedString("Change Address", comment: ""), style: .default) { _ in
                userInfoChangeVC.setViewType(viewType: .address)
                self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
            }
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
            
            userInfoChangeActionSheet.addAction(changeEmailAction)
            userInfoChangeActionSheet.addAction(chanePassAction)
            userInfoChangeActionSheet.addAction(changeAddressAction)
            userInfoChangeActionSheet.addAction(cancel)
            
            present(userInfoChangeActionSheet, animated: true)
        }
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
