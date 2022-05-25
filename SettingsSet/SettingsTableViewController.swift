//
//  SettingsTableViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 03.04.2022.
//

import UIKit
import CoreLocation
import MapKit

class SettingsTableViewController: UITableViewController, MKMapViewDelegate {
    
    @IBOutlet weak var companySiteButton: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var appThemeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    var mapV = SettingsMapView()
    var WEBurl = ""
    var routeEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure mapView
        mapV = mapView as! SettingsMapView
        mapV.configureMapView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addNotifications()
        
        if AppSettings.shared.signedIn {
            accountLabel.text = AppSettings.shared.user?.email
            signInButton.setTitle(NSLocalizedString("Sign Out", comment: ""), for: .normal)

        } else {
            accountLabel.text = NSLocalizedString("Authorization", comment: "")
            signInButton.setTitle(NSLocalizedString("Sign In", comment: ""), for: .normal)
        }
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    //    MARK:  App theme
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        switch appThemeSegmentedControl.selectedSegmentIndex{
        case 0: tabBarController?.overrideUserInterfaceStyle = .unspecified
            AppSettings.shared.appTheme = 0
        case 1: tabBarController?.overrideUserInterfaceStyle = .dark
            AppSettings.shared.appTheme = 1
        case 2: tabBarController?.overrideUserInterfaceStyle = .light
            AppSettings.shared.appTheme = 2
        default:
            tabBarController?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    //    MARK:  SingIn & SignOut
    
    
    @IBAction func signInButtonAction(_ sender: Any) {
        
        if AppSettings.shared.signedIn {
            
            let alert = UIAlertController(title: NSLocalizedString("Are You shure?", comment: ""), message: NSLocalizedString("Do You want to logOut?", comment: ""), preferredStyle: .alert)
            
            let alertYesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { UIAlertAction in
                FireAPI.shared.signOut()
                self.viewWillAppear(false)
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
    
    
//    MARK: - Notifications
    
    func addNotifications() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SignedIn"), object: nil, queue: nil) { _ in
            
            self.accountLabel.text = AppSettings.shared.user?.email
            self.signInButton.setTitle(NSLocalizedString("Sign Out", comment: ""), for: .normal)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("SignedOut"), object: nil, queue: nil) { _ in
            
            self.accountLabel.text = NSLocalizedString("Authorization", comment: "")
            self.signInButton.setTitle(NSLocalizedString("Sign In", comment: ""), for: .normal)
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
        case [2, 1]: // mapView
            
            if routeEnabled {
                let alert = UIAlertController(title: NSLocalizedString("Do you want to open maps?", comment: ""), message: NSLocalizedString("Another app will be open.", comment: ""), preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { _ in
                    self.mapV.openInNavigationApp(to: CLLocation(latitude: 48.002655, longitude: 37.840235))
                }
                
                alert.addAction(yesAction)
                alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .destructive))
                
                present(alert, animated: true)
                break
            }
            
            mapV.checkPermissions()
            mapV.route(to: CLLocation(latitude: 48.002655, longitude: 37.840235))
            routeEnabled = true
            

            

        case [2, 2]: // about dev
            WEBurl = "https://github.com/ASPIRINI1"
        default:
            break
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userInfoChangeVC = storyboard?.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoChangeViewController
        
//        Creating actionSheet
        if indexPath == [0, 1] { // user info change cell
            
            let userInfoChangeActionSheet = UIAlertController(title: NSLocalizedString("Select user info to change", comment: ""), message: nil, preferredStyle: .actionSheet)
            
//            Creating actionSheet action
            let changeEmailAction = UIAlertAction(title: NSLocalizedString("Change Email", comment: ""), style: .default) { _ in
                userInfoChangeVC.setViewType(viewType: .email)
                self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
            }
            
            let chanePassAction = UIAlertAction(title: NSLocalizedString("Change password", comment: ""), style: .default) { _ in
                userInfoChangeVC.setViewType(viewType: .password)
                self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
            }
            
            let changeAddressAction = UIAlertAction(title: NSLocalizedString("Change address", comment: ""), style: .default) { _ in
                userInfoChangeVC.setViewType(viewType: .address)
                self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
            }
            
            let changePhoneNumAction = UIAlertAction(title: "Change phone number", style: .default) { _ in
                userInfoChangeVC.setViewType(viewType: .phoneNum)
                self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
            }
            
            let deleteAccountAction = UIAlertAction(title: NSLocalizedString("Delete user account", comment: ""), style: .destructive) { _ in
                
//                creating confirming alert
                let alert = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: nil, preferredStyle: .alert)
                
//                confirming alert actions
                let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { _ in
                    FireAPI.shared.deleteAccount()
                    self.viewWillAppear(false)
                }
                let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default)
                
                alert.addAction(yesAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true)
            }
            
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
            
            userInfoChangeActionSheet.addAction(changeEmailAction)
            userInfoChangeActionSheet.addAction(chanePassAction)
            userInfoChangeActionSheet.addAction(changeAddressAction)
            userInfoChangeActionSheet.addAction(changePhoneNumAction)
            userInfoChangeActionSheet.addAction(deleteAccountAction)
            userInfoChangeActionSheet.addAction(cancel)
            
            present(userInfoChangeActionSheet, animated: true)
            
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
}

