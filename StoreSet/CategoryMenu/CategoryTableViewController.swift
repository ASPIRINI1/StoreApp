//
//  CategoryTableViewController.swift
//  StoreApp
//
//  Created by Станислав Зверьков on 16.04.2022.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    

    var selectedCategory = ""
    weak var storeDelegate: ConfigureStoreCVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createSubTableView(subCategories: [String]) -> UITableView {
        let subTableView = UITableView(frame: tableView.dequeueReusableCell(withIdentifier: "categoryCell")!.bounds)
        return subTableView
    }

    
//    MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        storeDelegate?.setProducts(category: AppSettings.shared.categories[indexPath.section].first!, subCategory: AppSettings.shared.categories[indexPath.section][indexPath.row])
        
        return indexPath
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return AppSettings.shared.categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppSettings.shared.categories[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell

        cell.label.text = AppSettings.shared.categories[indexPath.section][indexPath.row]
        
        if indexPath.row == 0 {
            cell.backgroundColor = .systemGray5
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 35
        } else {
            return 59.5
        }
    }
 
}
