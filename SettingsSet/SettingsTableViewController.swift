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
    
    //webView properties
    var WEBurl = ""
    
    //mapView properties
    var mapV = SettingsMapView()
    var routeEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure mapView
        mapV = mapView as! SettingsMapView
        mapV.configureMapView()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if AppSettings.shared.signedIn {
            accountLabel.text = AppSettings.shared.user?.email
            signInButton.setTitle(NSLocalizedString("Sign Out", comment: ""), for: .normal)

        } else {
            accountLabel.text = NSLocalizedString("Authorization", comment: "")
            signInButton.setTitle(NSLocalizedString("Sign In", comment: ""), for: .normal)
        }
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
                self.viewDidAppear(false)
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
            WEBurl = "https://foks-donetsk.com"
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
    
    // MARK: - Table view didSelectRowAt
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
//        Creating actionSheet
        if indexPath == [0, 1] { // user info change cell
            
            let userInfoChangeActionSheet = UserDataChangeActionSheet().create { changingType in
                
                let userInfoChangeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoChangeViewController
                userInfoChangeVC.viewType = changingType
                
                tableView.cellForRow(at: indexPath)?.isSelected = false
                
                guard changingType != .delete else {
                    
        //                creating confirming alert
                    let alert = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: nil, preferredStyle: .alert)
                    
        //                confirming alert actions
                    let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive) { _ in
                        FireAPI.shared.deleteAccount()
                        self.viewDidAppear(false)
                    }
                    let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default)
                    
                    alert.addAction(yesAction)
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true)
                    return
                }
                
                self.navigationController?.pushViewController(userInfoChangeVC, animated: true)
            }
            
            present(userInfoChangeActionSheet, animated: true)
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
}

